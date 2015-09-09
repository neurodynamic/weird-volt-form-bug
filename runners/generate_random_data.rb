require_relative 'find_or_create_methods'


def random_environment
  ['Mac OSX', 'Windows', 'Linux'].sample
end

def random_site
  ['First Example', 'Second Example', 'Third Example'].sample
end

def random_string(number_of_characters = 12)
  ('a'..'z').to_a.shuffle[0,number_of_characters].join
end

100.times do
  find_or_create_entry('urls', 'Site', random_site, "a random page #{random_string}", random_string)
end
