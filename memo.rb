class Memo
  def initialize(title:, body:)
    @title = title
    @body  = body
  end

  def save
    datas = CSV.read("data.csv")
    datas.push([SecureRandom.hex(10), @title, @body])
    write_csv(datas)
  end

  def self.update(id:, title:, body:)
    datas = CSV.read("data.csv")
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
    datas = CSV.read("data.csv")
    datas.delete_if{|data| data[0] == id}
    write_csv(datas)
  end

  def self.all
    CSV.read("data.csv")
  end

  def self.find(id)
    CSV.foreach("data.csv") do |row|
      return row if row[0] == id
    end
  end

  class << self
    private
    def write_csv(datas)
      CSV.open("data.csv", "wb") do |csv|
        datas.each do |data| 
          csv << data
        end
      end
    end
  end
end
