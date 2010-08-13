Puppet::Type.newtype(:cups_printer) do
	@doc = "Manage a cups printer." +
	       "	cups_printer { 'Brother-HL-2040': " +
	       "		uri            => 'ipp://localhost:631/printers/Brother-HL-2040', " +
	       "		info           => 'Brother-HL-2040', " +
	       "		location       => 'Room Name', " +
	       "		make_and_model => 'Brother HL-2060 Foomatic/hpijs-pcl5e (recommended)', " +
	       "		ensure         => present, " +
	       "	} "
	
	ensurable do
		newvalue(:present) do
			provider.create
		end

		newvalue(:absent) do
			provider.destroy
		end
		
		defaultto :present
	end
	
	newparam(:name) do
		desc "The name of the printer to be managed."
		isnamevar
	end
	
	newparam(:uri) do
		desc "The full URI to the printer.  For example: ipp://localhost:631/printers/Brother-HL-2040"
		
	end
	
	newproperty(:info) do
		desc "Human readable short description of the printer."
	end
	
	newproperty(:location) do
		desc "The human readable location of the printer.  (Optional)"
	end
	
	newproperty(:make_and_model) do
		desc "The full cups make and model of the printer."
	end
	
	autorequire(:service) do
		["cups"]
	end

	autorequire(:package) do
		["cups"]
	end

end

