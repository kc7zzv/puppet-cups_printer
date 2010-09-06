begin
    require 'shellwords'
rescue LoadError
    Puppet.warning "You need the ShellWords ruby module installed to manage cups printers."
end

Puppet::Type.type(:cups_printer).provide(:cups_printer) do
	desc "Manage a cups printer." +
	       "	cups_printer { 'Brother-HL-2040': " +
	       "		uri      => 'ipp://localhost:631/printers/Brother-HL-2040', " +
	       "		info     => 'Brother-HL-2040', " +
	       "		location => 'Room Name', " +
	       "		ppd_path => '/etc/cups/ppd/Brother-HL-2040.ppd', " +
	       "		ensure   => present, " +
	       "	} "
	
	def create
		#puts "Creating printer"
		create_printer( resource[:name] )
	end
	
	def destroy
		delete_printer( resource[:name] )
	end
	
	def exists?
		#puts "Testing if exists\n"
		printerList,defaultPrinter = get_printers()
		
		#Debug
		if printerList.length == 0 then puts "Empty printer list\n" end

		printerList.each {
			|printer|
			#puts "Printer: "+printer
			#puts "Name: "+resource[:name]
			if printer == resource[:name]
				then return true
			end }
		return false
	end
	
	
	def get_printers()
		printers = Array.new(0)
		defaultPrinter = nil
		printersFile = IO.popen("lpstat -p -d")
		printersFileLines = printersFile.readlines
		
		if( printersFileLines.length > 0 )
			defaultPrinter = printersFileLines.pop()
			defaultPrinter.slice!("system default destination: ")
			
			#remove printer status information
			printersFileLines.each { |printer| printers.push(printer.split(" ",3)[1]) }
		end
		return printers,defaultPrinter
	end
	
	def get_printer_info( printerName )
		printersFile = IO.popen("lpoptions -p "+ printerName)
		printerOptionsString = printersFile.readline
		shellwords = Shellwords.shellwords(printerOptionsString)
		pairs = shellwords.map{ |s| s.split('=', 2) }
		pairs = pairs.each { |option| if(option.length < 2) then option.push("") end }
		return Hash[*pairs.flatten]
	end

	def set_printer_value( printer_name, key, value )
		#puts "Setting \'"+key+"\' to \'"+value+"\' on \'"+resource[:name]+"\'"
		commandOutput = IO.popen("lpadmin -p \""+printer_name+
			"\" -o "+key+"=\"\\\""+value+"\\\"\"")
	end
	
	def get_printer_value( printer_name, key )
		#puts "Getting \'"+key+"\' on \'"+resource[:name]+"\'"
		values = get_printer_info( printer_name )
		#puts "Got value \'"+key+"\' on \'"+resource[:name]+"\'"
		return values[key]
	end

	def create_printer( printer_name )
		options = ""

		if( resource[:info] != nil )
			options = options+" -D \""+resource[:info]+"\" "
		end

		if( resource[:uri] != nil )
			options = options+" -i \""+resource[:uri]+"\" "
		end

		if( resource[:location] != nil )
			options = options+" -L \""+resource[:location]+"\" "
		end
		
		if( resource[:ppd_path] != nil )
			options = options+" -P \""+resource[:ppd_path]+"\" "
		end

		commandOutput = "lpadmin -p \""+printer_name+"\" "+options
#		commandOutput = IO.popen("lpadmin -p \""+printer_name"\"")
		puts "Creating "+printer_name+": "+commandOutput
	end
	
	def delete_printer( printer_name )
		commandOutput = ""
#		commandOutput = IO.popen("lpadmin -x \""+printer_name"\"")
		puts "Removing "+printer_name+": "+commandOutput
	end


	def uri
		return get_printer_value( resource[:name], "device-uri" )
	end
	
	def uri=(uri_string)
		set_printer_value( resource[:name], "device-uri", uri_string )
	end
	
	
	def info
		return get_printer_value( resource[:name], "printer-info" )
	end
	
	def info=(info_string)
		set_printer_value( resource[:name], "printer-info", info_string )
	end
	
	
	def location
		return get_printer_value( resource[:name], "printer-location" )
	end

	def location=(location_string)
		set_printer_value( resource[:name], "printer-location", location_string )
	end
	
	
	def ppd_path
		return "The full cups make and model of the printer."
	end
	
	def ppd_path=(ppd_path_string)
		puts "Not setting ppd_path"
		#set_printer_value( resource[:name], "ppd_path", ppd_path_string )
	end
	
end

