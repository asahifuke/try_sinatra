# frozen_string_literal: true

class Crud
  CSV_NAME = 'data.csv'

  def self.create(title:, body:)
    title = escape(title)
    body  = escape(body)
    datas = read_csv
    datas.push([SecureRandom.hex(20), title, body])
    write_csv(datas)
  end

  def self.all
    read_csv
  end

  def self.find(id)
    id = escape(id)
    CSV.foreach(CSV_NAME) do |row|
      return row if row[0] == id
    end
  end

  def self.update(id:, title:, body:)
    id    = escape(id)
    title = escape(title)
    body  = escape(body)
    datas = read_csv
    datas.map! do |data|
      if data[0] == id
        [id, title, body]
      else
        data
      end
    end
    write_csv(datas)
  end

  def self.destory(id)
    id    = escape(id)
    datas = read_csv
    datas.delete_if { |data| data[0] == id }
    write_csv(datas)
  end

  class << self
    private

    def write_csv(datas)
      CSV.open(CSV_NAME, 'wb') do |csv|
        datas.each do |data|
          csv << data
        end
      end
    end

    def read_csv
      CSV.read(CSV_NAME)
    end

    def escape(text)
      escape_characters = {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
        '\'' => '&quot;',
        '"' => '&#39;'
      }
      escape_characters.each do |key, value|
        text.gsub!(key, value)
      end
      text
    end
  end
end
