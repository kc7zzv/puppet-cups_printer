begin
    require 'shellwords'
rescue LoadError
    Puppet.warning "You need the ShellWords ruby module installed to manage cups printers."
end

Puppet::Type.type(:cups_printer).provide(:cups_printer) do
	desc "Manage a cups printer." +
	       "	cups_printer { 'Brother-HL-2040': " +
	       "		uri            => 'ipp://localhost:631/printers/Brother-HL-2040', " +
	       "		info           => 'Brother-HL-2040', " +
	       "		location       => 'Room Name', " +
	       "		make_and_model => 'Brother HL-2060 Foomatic/hpijs-pcl5e (recommended)', " +
	       "		ensure         => present, " +
	       "	} "
	
	def create
		puts "Creating printer..."
	end
	
	def destroy
		puts "Removing printer..."
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
		pairs = shellwords.map{ |s| s.split('=', 2) }.flatten
		return Hash[*pairs]
	end
	
end

