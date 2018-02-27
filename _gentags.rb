require 'yaml'

langs = []
Dir.glob(File.join('_posts','*.md')).each do |file|
	yaml_s = File.read(file).split(/^---$/)[1]
	yaml_h = YAML.load(yaml_s)
	lang = yaml_h['lang']
	if ((lang != nil) && (lang.is_a? String))
		langs += [lang]
	end
end
langs = langs.map{ |lang| lang.downcase }.uniq

messages = YAML.load_file("_data/messages.yml")

fcount = 0

langs.each do |lang|
	tags = []
	Dir.glob(File.join('_posts','*.md')).each do |file|
		yaml_s = File.read(file).split(/^---$/)[1]
		yaml_h = YAML.load(yaml_s)
		if yaml_h['lang'] != nil && yaml_h['lang'] == lang 
			tags_h = yaml_h['tags']
			if tags_h != nil 
				tags += tags_h
			end
		end
	end
	tags.map{ |tag| tag.downcase if tag.is_a? String }.uniq.each do |tag|
		tag_file = File.join("tags/#{lang}", "#{tag}.md")
		puts "Writing file '#{tag_file}' for tag '#{tag}' in language '#{lang}'..." 
		pretitle = messages['locales'][lang]['tagged_as']
		File.write tag_file, <<-EOF
---
layout: tag-page
title: "#{pretitle}: #{tag}"  
tag: #{tag}
lang: #{lang}
ref: tag-#{tag}
---
	EOF
	fcount = fcount + 1
	end
end

puts "#{fcount} files written!"

