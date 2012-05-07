module Crypto
  class Encrypt

    attr_accessor :key_mas_size, :bits_count, :thread_count

    def initialize()
      @key_mas_size = 8
      @bits_count = 32
      @thread_count = 8

      @G = [9,2,11,4,13,6,15,1,10,3,12,5,14,7,63,20,23,41,39,17,18,19,31,30,29,49,44,43,34,25,58,57,35,36,37,38,33,21,22,26,27,28,42,47,46,45,55,53,51,50,52,54,62,59,61,60]
      @H = [5,7,1,4,6,2,9,14,12,10,8,13,17,21,24,18,19,22,25,32,27,26,28,31,33,35,40,36,38,37,48,42,41,47,46,45,49,55,52,53,51,50,57,64,60,63,61,62]
      @IP = [14,10,6,2,16,12,8,4,13,9,5,1,15,11,7,3,52,41,18,17,24,36,48,33,21,19,35,34,60,53,49,22,27,31,32,50,51,47,46,45,44,43,42,40,39,38,37,30,29,28,26,25,64,63,62,61,59,54,58,55,57,56,20,23]
      @E = [8,1,2,3,4,5,4,5,6,7,8,1,9,11,13,15,16,10,16,10,12,14,9,11,17,21,23,24,21,23,22,18,20,21,19,23,25,29,25,28,32,31,31,30,27,26,26,30]
      @P = [4,7,2,5,8,1,3,6,16,12,10,9,14,15,11,13,24,21,18,17,22,23,19,20,27,29,32,31,30,28,26,25]
      @IPE = [12,4,16,8,11,3,15,7,10,2,14,6,9,1,13,5,20,19,24,17,18,22,21,23,28,30,32,26,25,27,29,31,40,33,39,37,36,38,34,35,42,44,43,46,47,48,45,41,56,54,52,50,49,51,53,55,58,60,64,59,57,61,62,63]
    end

    def relocate_to_mas(goals, mas, bits_count, res_bits_count)
      res_mas = Array.new
      res_mas.push(0)
      res_mas.push(0)
      step = 0
      goals.each{|i|
        step+=1
        el = mas[i/(bits_count+1)]
        if (i%bits_count) != 0
          shft = 1<<(bits_count-i%bits_count)
        else
          shft = 1
        end
        if (el&(shft))!=0
          if (step%res_bits_count == 0)
            res_mas[step/(res_bits_count+1)] += 1
          else
            res_mas[step/(res_bits_count+1)] += 1<<(res_bits_count-step%res_bits_count)
          end
        end
      }

      res_mas
    end

    def revert_relocate_to_mas(goals, mas, bits_count, res_bits_count)
      res_mas = Array.new
      res_mas.push(0)
      res_mas.push(0)
      step = 0
      goals.each{|i|
        step+=1
        el = mas[step/(bits_count+1)]
        if (step%bits_count) != 0
          shft = 1<<(bits_count-step%bits_count)
        else
          shft = 1
        end
        if (el&(shft))!=0
          if (i%res_bits_count == 0)
            res_mas[i/(res_bits_count+1)] += 1
          else
            res_mas[i/(res_bits_count+1)] += 1<<(res_bits_count-i%res_bits_count)
          end
        end
      }

      res_mas
    end

    def relocate_to_string(goals, mas, bits_count, bits_res)
      step = 0
      string=0
      goals.each{|i|
        step+=1
        el = mas[i/(bits_count+1)]
        if i%bits_count == 0
          shft = 1
        else
          shft = 1<<(bits_count-i%bits_count)
        end
        if (el&(shft))!=0
          if (step%bits_res == 0)
            string += 1
          else
            string += 1<<(bits_res-step%bits_res)
          end
        end
      }

      string
    end

    def revert_relocate_to_string(goals, mas, bits_count, bits_res)
      step = 0
      string=0
      goals.each{|i|
        step+=1
        el = mas[step/(bits_count+1)]
        if step%bits_count == 0
          shft = 1
        else
          shft = 1<<(bits_count-step%bits_count)
        end
        if (el&(shft))!=0
          if (i%bits_res == 0)
            string += 1
          else
            string += 1<<(bits_res-i%bits_res)
          end
        end
      }

      string
    end

    def relocate_string_to_sting(goals, string, bits_count, bits_res)
      step = 0
      res_string=0

      goals.each{|i|
        step+=1
        if i%bits_count == 0
          shft = 1
        else
          shft = 1<<(bits_count-i%bits_count)
        end
        if (string & shft)!=0
          if (i%bits_res)==0
            res_string += 1
          else
            res_string += 1<<(bits_res - step)
          end
        end
      }

      res_string
    end

    def circle_shift(elem, shift)
      new_elem = 0
      for shifting in 1..shift
        buf = elem & 1
        for i in 0..(@bits_count-@bits_count/@bits_count-1)
          bit_for_shift = buf
          if (i+1) != @bits_count-@bits_count/@bits_count
            buf = elem & 1<<(i+1)
            new_elem += bit_for_shift<<1
          else
            if buf > 0
              new_elem += 1
            end
          end
        end
        elem = new_elem
        new_elem=0
      end
      elem
    end

    def finally_key(keys_massive)
      step = 0
      key=relocate_to_string(@H, keys_massive, bits_count-1, 12)

      key
    end

    def split_on_two(x)
      b = Array.new
      b.push(0)
      b.push(0)

      b[0] = (x&(0b111111111111111111111111 << 24))>>24
      b[1] = x&0b111111111111111111111111

      b
    end

    def cutting(number)
      number = (number & 0b11111111111111111111)>>4

      number
    end

    def make_general_key_mas(word)
      key1=0
      key2=0
      key_mas = Array.new
      key_mas1 = Array.new
      key_mas2 = Array.new
      general_key_mas = word.to_s.split("")
      length = general_key_mas.length
      parnost = false
      key_mas = Array.new
      general_key_mas.each {|number|
        if parnost
          char = number[0].ord<<1|1
          parnost = false
        else
          char = number[0].ord<<1|0
          parnost = true
        end
        key_mas.push(char)
      }

      key_mas_old = key_mas.clone
      key_mas = relocate_to_mas(@G, key_mas_old, bits_count, bits_count-1)

      step = 0
      key_mas.each{|el|
        key_mas1[step] = circle_shift(el, 1)
        key_mas2[step] = circle_shift(el, 3)
        step+=1
      }

      key1 = finally_key(key_mas1)
      key2 = finally_key(key_mas2)

      return key1, key2

    end

    def begins_relocation(word)
      step=0
      result_mas = Array.new
      result_mas.push(0)
      result_mas.push(0)

      word = relocate_to_mas(@IP, word, bits_count, bits_count)

      word
    end

    def replacement(word, key1, key2)
      left = word[0]
      right = word[1]

      for stage in 1..2

        er = relocate_string_to_sting(@E, right, @bits_count, 48)

        if stage == 1
          x = er^key1
        else
          x = er^key2
        end
        b = split_on_two(x)

        b[0] = cutting(b[0])
        b[1] = cutting(b[1])

        y=relocate_to_string(@P, b, @bits_count/2, @bits_count)

        buf = left^y
        left = right
        right = buf

      end
      word[0] = right
      word[1] = left

      word
    end

    def end_relocation(word)
      word = relocate_to_mas(@IPE, word, bits_count, bits_count)

      word
    end
    #-----------------------------------------------------------------------Description-------------------------------------------------------------------------
    def revert_end_relocation(word)
      word = revert_relocate_to_mas(@IPE, word, bits_count, bits_count)

      word
    end

    def revert_begins_relocation(word)
      word = revert_relocate_to_mas(@IP, word, bits_count, bits_count)

      word
    end

    def revert_replacement(word, key1, key2)
      left = word[1]
      right = word[0]

      for stage in 1..2

        er = relocate_string_to_sting(@E, left, @bits_count, 48)

        if stage == 1
          x = er^key2
        else
          x = er^key1
        end
        b = split_on_two(x)

        b[0] = cutting(b[0])
        b[1] = cutting(b[1])

        y = relocate_to_string(@P, b, @bits_count/2, @bits_count)

        buf = left
        left = right^y
        right = buf

      end

      word[0] = left
      word[1] = right

      word

    end

    def text_8_to_32_mas(text)
      mas = Array.new
      mas.push(0)
      mas.push(0)

      for i in 1..8
        if (i%4) == 0
          mas[i/5] += text[i-1].ord
        else
          mas[i/5] += text[i-1].ord<<(8*(4-i%4))
        end
      end
      mas
    end

    def text_32_to_8_string(text)
      mas = Array.new

      for i in 1..8
        if (i%4) == 0
          mas.push((text[i/5] & 0b11111111).chr)
        else
          mas.push(((text[i/5] & (0b11111111<<(8*(4-i%4))))>>(8*(4-i%4))).chr)
        end
      end

      mas
    end


    def encrypt(key, text)
      key1, key2 = make_general_key_mas(key)
      text = begins_relocation(text)
      for i in 1..16
        text = replacement(text, key1, key2)
      end
      text = end_relocation(text)

      text
    end

    def descrypt(key, text)
      key1, key2 = make_general_key_mas(key)
      text = revert_end_relocation(text)
      for i in 1..16
        text = revert_replacement(text, key1, key2)
      end
      text = revert_begins_relocation(text)

      text
    end

  end
end