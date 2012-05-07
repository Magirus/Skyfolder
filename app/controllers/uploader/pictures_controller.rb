class Uploader::PicturesController < ApplicationController

  attr_accessor :flag

  def ischecked
    @flag = params[:enc]
    respond_to do |format|
      render :json => true
    end
  end

  def index
    @pictures = Picture.find_all_by_user_id(current_user.id)
    render :json => @pictures.collect { |p|
      if p.key == "0"
        p.to_jq_upload
      else
        p.to_jq_upload_enc
      end
    }.to_json
  end

  def create
    @flag = params[:enc]
    @file_exist = false

    @user_id = current_user.id
    p_attr = params[:picture]
    p_attr[:user_id] = @user_id
    p_attr[:file] = params[:picture][:file].first if params[:picture][:file].class == Array

    if @flag == "true"
      p_attr[:key] = generate_key
    else
      p_attr[:key] = 0
    end

    @picture = Picture.new(p_attr)
    @maybe_copy = Picture.find_by_file(@picture.file.filename)
    if @maybe_copy != nil
      if (@maybe_copy.file != nil)
        @file_exist = true
        @maybe_copy.destroy
      end
    end

    if @flag == "true"
      encryption(@picture.file.file.file, @picture.key)
    end

    if @picture.save

      respond_to do |format|
        format.html {
          if @picture.key == 0
            json = @picture.to_jq_upload
          else
            json = @picture.to_jq_upload_enc
          end
          if (@file_exist == true)
            json[:fileexist] = true
            render :json => [json].to_json, :content_type => 'text/html', :layout => false
          else
            json[:fileexist] = false
            render :json => [json].to_json, :content_type => 'text/html', :layout => false
          end
        }
        format.json {
          if @picture.key == 0
            json = @picture.to_jq_upload
          else
            json = @picture.to_jq_upload_enc
          end
          if (@file_exist == true)
            json[:fileexist] = true
            render :json => [json].to_json
          else
            json[:fileexist] = false
            render :json => [json].to_json
          end
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end

  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    render :json => true
  end

  def destroy_by_name
    @picture = Picture.find_by_file(params[:file])
    @picture.destroy
    render :json => true
  end

  def upload

    @flag = params[:enc]
    @file_exist = false

    @user_id = params[:id]
    p_attr = Hash.new
    p_attr[:user_id] = @user_id
    p_attr[:file] = params[:file]

    if @flag == "true"
      p_attr[:key] = generate_key
    else
      p_attr[:key] = 0
    end

    @picture = Picture.new(p_attr)
    @maybe_copy = Picture.find_by_file(@picture.file.filename)
    if @maybe_copy != nil
      if (@maybe_copy.file != nil)
        @file_exist = true
        @maybe_copy.destroy
      end
    end

    if @flag == "true"
      encryption(@picture.file.file.file, @picture.key)
    end

    if @picture.save

      respond_to do |format|
        format.html
        format.json {
            render :json => true
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  private
  def generate_key
    key = ""
    for i in 1..32
      el = rand(127)
      key+=el.chr
    end
    key
  end

  def encryption(name, key)
    require "crypto/encript"

      crypt = Crypto::Encrypt.new

      file = File.open(name, "r+b")
      size = File.size(file)
      enc = File.open(name, "r+b")
      file_length = 0
      no_data = false

      t1 = Time.new
    while file_length != size
      word = Array.new
      coded_flags = Array.new
      slots=1
      while ((no_data!=true) && (slots!=(crypt.thread_count+1)))
        ost = size - file_length
        if ost<8
          coded_flags[slots-1] = 0
          no_data = true
          word[slots-1] = Array.new
          for i in 1..ost
            word[slots-1][i-1] = file.getc
          end
          file_length += word[slots-1].size
          slots+=1
        else
          coded_flags[slots-1] = 1
          word[slots-1] = Array.new
          for i in 1..8
            word[slots-1][i-1] = file.getc
          end
          file_length += word[slots-1].size
          slots+=1
        end
      end

      threads = Array.new

      for slots in 1..word.size
        if (word[slots-1].size == 8)
          threads[slots-1] = Thread.new{
            word[slots-1] = crypt.encrypt(94, crypt.text_8_to_32_mas(word[slots-1]))
          }.join
        end
      end

      for slots in 1..word.size
        if (coded_flags[slots-1]==0)
          for i in 1..word[slots-1].size
            enc.putc(word[slots-1][i-1])
          end
        else
          encrypt = crypt.text_32_to_8_string(word[slots-1])
          for i in 1..8
            enc.putc(encrypt[i-1])
          end
        end
      end

    end

      t2 = Time.new
      puts("Time spended is #{t2-t1}")

      file.close
      enc.close
    end

end