require 'base64'

unless ARGV.length == 1
    puts "./decode_logs.rb </var/log/apache2/access.log>\n"
    exit!
end

File.open(ARGV[0], "r") do |infile|
    while (line = infile.gets)
	if line =~ /index.php\?id\=/ then
		ip = line.split(" ")[1]
		date = line.split(" ")[4].split("[")[1]
		url = line.split(" ")[7].split("?")[1]
		
		if url =~ /id/ then
			base64 = url[3..300]
			puts ip + " - " + date + " - " + Base64.decode64(base64)
		end
	end
    end
end
