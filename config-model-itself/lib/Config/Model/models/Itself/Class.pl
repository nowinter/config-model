# $Author$
# $Date$
# $Revision$

#    Copyright (c) 2007-2008 Dominique Dumont.
#
#    This file is part of Config-Model-Itself.
#
#    Config-Model-Itself is free software; you can redistribute it
#    and/or modify it under the terms of the GNU Lesser Public License
#    as published by the Free Software Foundation; either version 2.1
#    of the License, or (at your option) any later version.
#
#    Config-Model-Itself is distributed in the hope that it will be
#    useful, but WITHOUT ANY WARRANTY; without even the implied
#    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#    See the GNU Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model-Itself; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA

[
  [
   name => "Itself::Class",

   class_description => "Configuration class. This class will contain elements",

   'element' 
   => [

       'element' => {
		     type       => 'hash',
		     level      => 'important',
		     ordered    => 1,
		     index_type => 'string',
		     cargo => { type => 'node',
				config_class_name => 'Itself::Element',
			      },
		    },

       'include' => { type => 'list',
		      cargo => {
				type => 'leaf',
				value_type => 'reference',
				refer_to => '! class',
			       }
		    } ,

       'include_after' => { type => 'leaf',
			    value_type => 'reference',
			    refer_to => '- element',
			  } ,

       'class_description'
       => { 
	   type => 'leaf',
	   value_type => 'string' ,
	  },

       generated_by => { 
			type => 'leaf',
			value_type => 'uniline' ,
		       },
       'read_config'
       => {
	   type => 'list',
	   cargo => { type => 'node',
		      config_class_name => 'Itself::ConfigRead',
		    },
	  },

       'write_config'
       => {
	   type => 'list',
	   cargo => { type => 'node',
		      config_class_name => 'Itself::ConfigWrite',
		    },
	  },
      ],
   'description' 
   => [
       element => "Specify the elements names of this configuration class.",
       include => "Include the specification of another class into this class.",
       include_after => "insert the included elements after a specific element" ,
       class_description => "Explain the purpose of this configuration class",
       read_config => "Specify the Perl class(es) and function(s) used to read configuration data. The specified function will be tried in sequence to get configuration data. " ,
       write_config => "Specify the Perl class and function used to write configuration data." ,
       generated_by => "When set, this class was generated by some program. You should not edit it as your modification may be clobbered later on",
      ],
  ],

  [
   name => "Itself::ConfigWR",

   'element' 
   => [
       'backend' => { type => 'leaf',
		      value_type => 'enum',
		      choice => [qw/cds_file perl_file ini_file augeas custom/],
		      description => 'specifies the backend to store permanently configuration data.',
		      help => {
			       cds_file => "file with config data string. This is Config::Model own serialisation format, designed to be compact and readable.",
			       ini_file => "Ini file format. Beware that the structure of your model must match the limitations of the INI file format, i.e only a 2 levels hierarchy",
			       perl_file => "file with a perl data structure",
			       custom => "Custom format. You must specify your own class and method to perform the read or write function. See Config::Model::AutoRead doc for more details",
			       augeas => "Experimental backend with RedHat's Augeas library. See http://augeas.net for details",
			      }
		    },

       'class'
       => {
	   type => 'leaf',
	   value_type => 'uniline' ,
	   level => 'hidden',
	   warp => { follow => '- backend',
		     rules => [ custom => { level => 'normal',
					    mandatory => 1,
					  }
			      ],
		   }
	  },
       'config_dir'
       => {
	   type => 'leaf',
	   value_type => 'uniline' ,
	   level => 'normal',
	  },

       'save'
       => {
	   type => 'leaf',
	   value_type => 'enum' ,
	   choice => [qw/backup newfile/],
	   level => 'hidden',
	   description => 'Specify how to save the configuration file. Either create a newfile (with extension .augnew, and do not overwrite the original file) or move the original file into a backup file (.augsave extension)',
	   warp => { follow => '- backend',
		     rules => [ augeas => { level => 'normal',
					    mandatory => 1,
					  }
			      ],
		   }
	  },
       'set_in'
       => {
	   type => 'leaf',
	   value_type => 'reference' ,
	   refer_to => '- - element',
	   level => 'hidden',
	   description => 'Sometimes, the structure of a file loaded by Augeas starts directly with a list of items. For instance, /etc/hosts structure starts with a list of lines that specify hosts and IP adresses. This parameter specifies an element name in Config::Model root class that will hold the configuration data retrieved by Augeas',
	   warp => { follow => '- backend',
		     rules => [ augeas => { level => 'normal',
					  }
			      ],
		   }
	  },
      ],

  ],

  [
   name => 'Itself::ConfigRead',
   include => "Itself::ConfigWR",

   'element' 
   => [
       'function'
       => {
	   type => 'leaf',
	   value_type => 'uniline' ,
	   level => 'hidden',
	   warp => { follow => '- backend',
		     rules => [ custom => { level => 'normal',
					    built_in => 'read',
					  }
			      ],
		   }
	  },
       ],

  ],

  [
   name => 'Itself::ConfigWrite',
   include => "Itself::ConfigWR",

   'element' 
   => [
       'function'
       => {
	   type => 'leaf',
	   value_type => 'uniline' ,
	   level => 'hidden',
	   warp => { follow => '- backend',
		     rules => [ custom => { level => 'normal',
					    built_in => 'write',
					  }
			      ],
		   }
	  },
      ],
  ],

];
