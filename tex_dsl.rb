
module TexDSL
	def self.included(receiver)
		Kernel.puts "% this tex file is generated by #{self} at #{Time.now}"
	end

	module_function

	# 
	# Modify method_missing
	# 
	alias_method :original_method_missing, :method_missing

	def method_missing(method, *args, &block)
		if args.length.between?(1, 5)
			make_command(method, args)
		else
			original_method_missing(method, *args, &block)
		end
	end
	
	# 
	# Delete indent on here-document
	# 
	def puts(*strs)
		strs.each do |str|
			Kernel.puts str.to_s.unindent
		end
	end

	String.class_eval do
		def unindent
			gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
		end
	end

	# 
	# Make block command
	# 
	def block_command(cmd)
		puts "\\begin{#{cmd}}"
		yield
		puts "\\end{#{cmd}}"
	end

	alias_method :start, :block_command
	alias_method :set, :block_command

	# 
	# Make command
	# 
	# note: this method is under method missing
	def make_command(func_name, args)
		args = [args] unless args.respond_to?(:inject)

		out = args.inject("\\#{func_name}") do |memo, arg|
			if arg.kind_of?(Array)
				memo << "[#{arg.join(',')}]"
			elsif arg.kind_of?(String)
				memo << "{#{arg}}"
			end
		end

		puts out
	end


end




include(TexDSL)

documentclass %w(a4j titlepage), 'jarticle'
usepackage ['utf8'], 'inputenc'
usepackage 'fancybox, ascmac'
usepackage 'amsmath, amssymb'
usepackage 'fancybox, ascmac'
usepackage ['dvipdfmx'], 'graphicx'
usepackage 'verbatim'
# to display code list
usepackage 'ascmac'
usepackage 'here'
usepackage 'txfonts'
usepackage 'listings, jlisting'
renewcommand '\lstlistingname', 'List'

lstset <<-EOS
	language=c,
	basicstyle=\\ttfamily\\small, % font and size
	commentstyle=\\textit, % font of comment
	classoffset=1,
	keywordstyle=\\bfseries,
	frame=tRBl,
	framesep=5pt,
	showstringspaces=false,
	numbers=left,
	stepnumber=1,
	numberstyle=\\footnotesize,
	tabsize=3 % depth of indent
EOS

title 'How to write tex-DSL'
author '@TeX2e'
date Time.now.strftime('%Y/%m/%d')

set :document do
	maketitle ''
	thispagestyle 'empty'
	newpage ''
	setcounter val: 'page', subval: '1'

	section 'Overview'

	set :screen do
		set :verbatim do
			puts '$ gem install kramdown'
		end
	end

	set :center do
		
	end
end







