require 'yaml'
chapters = []

Dir.glob('_posts/*.md') do |post|
  ignore, meta, content = IO.read(post).split(/---[\r\n]+/, 3)
  meta = YAML.load meta
  directory = "chapter#{meta['category']}"
  Dir.mkdir directory unless Dir.exist? directory
  meta['realpath'] = File.join(directory, meta['path'])
  IO.write meta['realpath'], content
  chapters[meta['category']] ||= []
  chapters[meta['category']].push meta
end
chapters.each{|sections|sections.sort_by!{|meta|meta['path'][/\d{5}/]}}

summary = ['* [简介](README.md)', chapters.each_with_index.map {|sections, index|
    ignore, meta, content = IO.read("index#{index}.md").split(/---[\r\n]+/, 3)
    meta = YAML.load meta
    ["* #{meta['title']}", sections.map{|meta| "    * [#{meta['title']}](#{meta['realpath']})"}]
}].join("\n")

IO.write 'SUMMARY.md', summary