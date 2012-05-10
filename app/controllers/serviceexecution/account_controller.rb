class Serviceexecution::AccountController < ApplicationController

  def showuser
    files_paths = Array.new
    if current_user != nil
      user_id = current_user.id
    else
      user_id = params[:id]
    end
    files_paths.push(user_id)
    files = Picture.find_all_by_user_id(user_id)
    files.each do |file|
        files_paths.push(file.file.model[:file])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => files_paths }
    end
  end

  def check_dec_dir(folder)
    if !File.exists?(folder)
      Dir.mkdir(folder)
    end
  end

  def request_file_size
    if (current_user) != nil
      user_id = current_user.id
    else
      user_id = params[:id]
    end
    base_url = "#{Rails.root}/tmp/FILES/#{user_id}/"

    file = Picture.find_by_file(params[:path])
    send_file base_url+params[:path], :type => "application", :x_sendfile => true
  end

  def download
    require "crypto/encript"

    if (current_user) != nil
      user_id = current_user.id
    else
      user_id = params[:id]
    end
    base_url = "#{Rails.root}/tmp/FILES/#{user_id}/"
    dec_url = "#{Rails.root}/tmp/FILES/#{user_id}/tmp/"

    check_dec_dir(dec_url)

    file = Picture.find_by_file(params[:path])

    if file.key != "0"
      crypt = Crypto::Encrypt.new
      enc = File.open(base_url+params[:path], "r+b")
      size = File.size(enc)
      dec = File.open(dec_url+params[:path], "wb")

      file_length = 0
      no_data = false

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
              word[slots-1][i-1] = enc.getc
            end
            file_length += word[slots-1].size
            slots+=1
          else
            coded_flags[slots-1] = 1
            word[slots-1] = Array.new
            for i in 1..8
              word[slots-1][i-1] = enc.getc
            end
            file_length += word[slots-1].size
            slots+=1
          end
        end

        threads = Array.new
        for slots in 1..word.size
          if (word[slots-1].size == 8)
            threads[slots-1] = Thread.new{
              word[slots-1] = crypt.descrypt(94, crypt.text_8_to_32_mas(word[slots-1]))
            }.join
          end
        end

        for slots in 1..word.size
          if (coded_flags[slots-1]==0)
            for i in 1..word[slots-1].size
              dec.putc(word[slots-1][i-1])
            end
          else
            descrypt = crypt.text_32_to_8_string(word[slots-1])
            for i in 1..8
              dec.putc(descrypt[i-1])
            end
          end
        end

      end

      enc.close
      dec.close

      send_file dec_url+params[:path], :type => "application", :x_sendfile => true

    else
      send_file base_url+params[:path], :type => "application", :x_sendfile => true
    end

  end


end
