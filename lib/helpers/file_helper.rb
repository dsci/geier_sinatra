module FileHelper
  def read_file(path)
    file = File.open(path)
    content = ""
    file.each do |line|
      content += line
    end
    return content
  end

  def content_file_path(file)
    File.join(File.dirname(__FILE__), "../files/#{file}")
  end
end