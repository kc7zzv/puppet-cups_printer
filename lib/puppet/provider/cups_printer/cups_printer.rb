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
		return false
	end
	
end
