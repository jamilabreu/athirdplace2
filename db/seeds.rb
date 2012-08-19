# 1 - 2
genders = %W[ Female Male ]
genders.each do |gender|
  Community.create name: gender, subdomain: gender.parameterize, display_name: "#{gender} Student + Professional Network", community_type: "Gender"
end

# 3 - 5
standing = %W[ Alumni #{'Graduate Student'} Undergraduate ]
standing.each do |standing|
  Community.create name: standing, subdomain: standing.delete(" ").parameterize, display_name: "#{standing} Network", community_type: "Standing"
end

# 6 - 13
degree = %W[ Associate's Bachelor's Master's Doctoral #{"Pursuing Associate's"} #{"Persuing Bachelor's"} #{"Persuing Master's"} #{"Pursuing Doctoral"} #{"High School"} ]
degree.each do |degree|
  Community.create name: degree, subdomain: degree.delete(" ").delete("'").parameterize, display_name: "#{degree} Network", community_type: "Degree"
end

# 14 - 56
field = %W[ Agriculture Anthropology Architecture #{'Area Studies'} Archaeology Astronomy Biology Business Chemistry #{'Cognitive Science'} Communications
  #{'Computer Science'} #{'Ethnic Studies'} Divinity Economics Education Engineering Entertainment Environment Finance #{'Gender Studies'} 
  Geography History Journalism Law Linguistics Literature Marketing Mathematics Medicine Military #{'Performing Arts'} Philosophy Physics #{'Political Science'}
  #{'Public Health'} Psychology Religion #{'Sexuality Studies'} #{'Social Work'} Sociology Sports Technology Transportation #{'Visual Arts'} Writing ]
field.each do |field|
  Community.create(name: field, subdomain: field.delete(" ").parameterize, display_name: "#{field} Student + Professional Network", community_type: "Field")
end

# 57 - 58
relationship = %W[ Single #{'In a Relationship'} Married ]
relationship.each do |relationship|
  Community.create(name: relationship, subdomain: relationship.delete(" ").parameterize, display_name: "#{relationship} Network", community_type: "Relationship")
end

orientation = { "Heterosexual" => [], "LGBT" => %W[ Lesbian Gay Bisexual Transgender ] }
orientation.each do |key, value|
  c = Community.create(name: key, subdomain: key.delete(" ").delete("-").parameterize, display_name: "#{key} Student + Professional Network", community_type: "Orientation")
  value.each { |v| c.children.create(name: v, subdomain: v.delete(" ").delete("-").parameterize, display_name: "#{v} Student + Professional Network", community_type: "Orientation") }
end

# 70 - 84
religion = %W[ Agnostic Athiest Bahai Buddhist Christian Confucianist Hindu Jain Jewish Muslim Rasta Shintoist Sikh Taoist Wicca ]
religion.each do |religion|
  Community.create(name: religion, subdomain: religion.delete(" ").parameterize, display_name: "#{religion} Student + Professional Network", community_type: "Religion")
end

# 84 - 104
ethnicity = {
  "African" => %W[ African-American Guyanese Nigerian Ethiopian Eritrean #{'South African'} Egyptian Algerian #{'Cape Verdean'} ], 
  "Latino" => %W[ Dominican #{'Puerto Rican'} Mexican Cuban Columbian Brazilian Bolivian Argentinian Chilean #{'Costa Rican'} Ecuadorian Guyanese 
    Uruguayan Peruvian Paraguayan Portuguese Guatemalan Salvadorian Venezuelan Panamanian Honduran ], 
  "West Indian" => %W[ Jamaican Trinidadian Haitian ],
  "Middle Eastern" => %W[ Afghan Albanian Vietnamese Armenian Indonesian Israeli ],
  "Asian" => %W[ Chinese Indian Filipino Japanese Taiwanese Korean ],
  "European" => %W[ Italian Irish French German British Dutch Russian Spaniard Greek Scottish ],
  "Native American" => []}
ethnicity.each do |key, value|
  c = Community.create(name: key, subdomain: key.delete(" ").delete("-").parameterize, display_name: "#{key} Student + Professional Network", community_type: "Ethnicity",
  name_singular: key, name_plural: key.pluralize)
  value.each { |v| c.children.create(name: v, subdomain: v.delete(" ").delete("-").parameterize, display_name: "#{v} Student + Professional Network", community_type: "Ethnicity", 
  name_singular: v, name_plural: v.pluralize ) }
end

puts 'Countries...'
require 'csv'
CSV.foreach('db/data/countrycodes.csv', {encoding: "ISO-3166-1:UTF-8", headers: true}) do |row|
  Community.create!(
    name: row[0],
    subdomain: row[0].delete(" ").parameterize,
    display_name: "#{row[0]} Student + Professional Network",
    community_type: "Country",
    country_code: row[1]
  )
  puts row[0] 
end

puts 'States...'
CSV.foreach('db/data/provincecodes.csv', {encoding: "ISO-3166-1:UTF-8", headers: true}) do |row|
  country = Community.find_by(country_code: row[3], community_type: "Country")
  country.children.create!(
    name: row[0],
    subdomain: row[0].delete(" ").parameterize,
    display_name: "#{row[0]} Student + Professional Network",
    community_type: "State",
    state_code: row[1]
  )
  puts row[0] 
end

puts 'Cities...'
CSV.foreach('db/data/cities_MASTER.csv', {encoding: "ISO-8859-1:UTF-8", headers: true}) do |row|
  state = Community.find_by(state_code: row[4], community_type: "State")
  state.children.create!(
    name: row[2],
    subdomain: row[2].delete(" ").parameterize,
    display_name: "#{row[2]} Student + Professional Network",
    community_type: "City"
  )
  puts row[2] + row[1] + row[0] 
end

puts 'Schools...'
CSV.foreach('db/data/colleges.csv', {encoding: "ISO-8859-1:UTF-8", headers: true}) do |row|
  Community.create!(
    name: row[0],
    subdomain: row[0].to_s.delete(" ").delete("-").parameterize,
    display_name: "#{row[0]} Student + Alumni Network",
    community_type: "School",
    address: row[1]
  )
  puts row[0]
end
=begin
puts 'Cities...'
CSV.foreach('db/data/world_cities_MASTER.csv', {encoding: "ISO-8859-1:UTF-8", headers: true}) do |row| 
  if row[2] == "United States"
    geocoder = Geocoder.search([row[4].to_f, row[5].to_f])
    state = Community.find_by(name: geocoder.map(&:state).first, community_type: "State")
    state.children.create!(
      name: row[1],
      subdomain: row[1].to_s.delete(" ").delete("-").parameterize,
      display_name: "#{row[1]} Student + Professional Network",
      community_type: "City",
      country: row[2],
      country_code: row[3],
      coordinates: [row[4].to_f, row[5].to_f] 
    )
    sleep 1.5
  else
    country = Community.find_by(name: row[2], community_type: "Country")
    country.children.create!(
      name: row[1],
      subdomain: row[1].to_s.delete(" ").delete("-").parameterize,
      display_name: "#{row[1]} Student + Professional Network",
      community_type: "City",
      country: row[2],
      country_code: row[3],
      coordinates: [row[4].to_f, row[5].to_f] 
    )
  end
  puts row[1]
end


20.times do
  uid = Random.new.rand(300000..302714)
  first = Faker::Name.first_name
  last = Faker::Name.last_name
  User.create!(
    email: Faker::Internet.email,
    provider: "facebook",
    uid: uid,
    name: "#{first} #{last}",
    first_name: first,
    last_name: last,
    image: "http://graph.facebook.com/#{uid}/picture?type=square",
    normal_image: "http://graph.facebook.com/#{uid}/picture?type=normal",
    large_image: "http://graph.facebook.com/#{uid}/picture?type=large",
    facebook_url: "http://www.facebook.com/#{uid}",
    show_facebook_url: uid % 2 == 0 ? true : false,
    bio: Faker::Lorem.paragraph,
    community_ids: [ Community.find_by(name: "Dominican").id.to_s, Community.filtered_by(:gender).sample.id.to_s, 
                     Community.filtered_by(:standing).sample.id.to_s, Community.filtered_by(:degree).sample.id.to_s, 
                     Community.filtered_by(:field).sample.id.to_s, Community.filtered_by(:relationship).sample.id.to_s, 
                     Community.filtered_by(:orientation).sample.id.to_s, Community.filtered_by(:religion).sample.id.to_s,
                     Community.filtered_by(:ethnicity).sample.id.to_s, Community.filtered_by(:state).sample.id.to_s, 
                     Community.filtered_by(:city).sample.id.to_s, Community.filtered_by(:school).sample.id.to_s ],
    friend_ids: [ Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, 
                  Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, 
                  Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, Random.new.rand(300000..302714).to_s, 
                  Random.new.rand(300000..302714).to_s ]
  )
end

10.times do
  Message.create!(body: Faker::Lorem.paragraph, user_ids: [ User.all.sample.id.to_s, User.last.id.to_s ])
  Post.create!(body: Faker::Lorem.paragraph, user_id: User.last.id.to_s, community_ids: [ Community.find_by(name: "Dominican").id.to_s, Community.all.sample.id.to_s ])
end
=end