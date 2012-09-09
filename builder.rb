#!/usr/local/bin/ruby

require 'rubygems'
require 'kirbybase'
require 'fileutils'

$home = '/usr/local/all_builder/'
$all  = '/var/majordomo/lists/all'

def main
  loop do
    db = KirbyBase.new(:local, nil, nil, $home + 'data')

    all_list = db.get_table(:all_list)

    puts "1. Add user to all list"
    puts "2. Delete user to all list"
    puts "3. Exit"

    choice = gets

    case choice.to_i
      when 1
        puts ""
        add(all_list)
        puts ""
      when 2
        puts ""
        del(all_list)
        puts ""
      when 3
        exit;
    end
  end
end

def add(list)
  print "Type email to add: "
  email = gets
  email.chomp!
  puts ""
 
  result_set = list.select { |r| r.email == email }
  if result_set.size > 0
    puts "Duplicate email."
    return
  end

  list.insert(email)
  build(list)
  puts "Added #{email} to the all list."
end

def del(list)
  print "Type email to delete: "
  email = gets
  email.chomp!
  puts ""

  count = list.delete { |r| r.email == email }
  list.pack

  build(list)
  puts "#{email} not found." if count == 0
  puts "Deleted #{email} from the all list." unless count == 0
end

def build(list)
  File.open($all,'w') do |file|
    list.select.sort(:email).email.each do |e|
      file << e << "\n"
    end
  end
  FileUtils.chown('majordomo','majordomo',$all)
end

main()
