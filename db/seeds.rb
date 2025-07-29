# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Category.create!([
  { name: "Chair"},
  { name: "Wardrobe"},
  { name: "Sofa"},
  { name: "Bed"},
  { name: "Table"},
  { name: "Decor"}
])

user1 = User.create!(email: "user1@example.com", password: "123456", name: "user1", address: "Hanoi Vietnam")
user2= User.create!(email: "user2@example.com", password: "123456", name: "user2", address: "Ho Chi Minh Vietnam")
user3 = User.create!(email: "user3@example.com", password: "123456", name: "user3", address: "Ho Chi Minh Vietnam")
user4 = User.create!(email: "user4@example.com", password: "123456", name: "user4", address: "Ho Chi Minh Vietnam")
user5 = User.create!(email: "user5@example.com", password: "123456", name: "user5", address: "Ho Chi Minh Vietnam")
user6 = User.create!(email: "user6@example.com", password: "123456", name: "user6", address: "Ho Chi Minh Vietnam")

chair_category = Category.find_by(name: "Chair")
2.times do |i| 
  chair = Product.create!({

    name: "Comfortable Chair #{i+1}",
    description: "A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.A very comfortable and stylish chair.",
    price: 10 + i*20,
    stock: 20,
    category: chair_category,
    is_deleted: false
  })
  
  chair.images.attach(io: File.open("db/image/chair/chair#{i+1}_1.webp"), filename: chair.name)
  chair.images.attach(io: File.open("db/image/chair/chair#{i+1}_2.webp"), filename: chair.name)
  chair.images.attach(io: File.open("db/image/chair/chair#{i+1}_3.webp"), filename: chair.name)
  chair.images.attach(io: File.open("db/image/chair/chair#{i+1}_4.webp"), filename: chair.name)
  chair.images.attach(io: File.open("db/image/chair/chair#{i+1}_5.webp"), filename: chair.name)
  chair.reviews.create!(user: user1, star: 5, comment: "Chair review by user 1")
  chair.reviews.create!(user: user2, star: 4, comment: "Chair review by user 2")
  chair.reviews.create!(user: user3, star: 3, comment: "Chair review by user 3")
  chair.reviews.create!(user: user4, star: 2, comment: "Chair review by user 4")
  chair.reviews.create!(user: user5, star: 1, comment: "Chair review by user 5")
  chair.reviews.create!(user: user6, star: 5, comment: "Chair review by user 6")

end

table_category = Category.find_by(name: "Table")
2.times do |i| 
  table = Product.create!({

    name: "Comfortable table #{i+1}",
    description: "A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.A very comfortable and stylish table.",
    price: 33 + i*21,
    stock: 20,
    category: table_category,
    is_deleted: false
  })

  table.images.attach(io: File.open("db/image/table/table#{i+1}_1.webp"), filename: table.name)
  table.images.attach(io: File.open("db/image/table/table#{i+1}_2.webp"), filename: table.name)
  table.images.attach(io: File.open("db/image/table/table#{i+1}_3.webp"), filename: table.name)
  table.images.attach(io: File.open("db/image/table/table#{i+1}_4.webp"), filename: table.name)
  

end

sofa_category = Category.find_by(name: "Sofa")
2.times do |i| 
  sofa = Product.create!({

    name: "Comfortable sofa #{i+1}",
    description: "A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.A very comfortable and stylish sofa.",
    price: 10 + i*20,
    stock: 20,
    category: sofa_category,
    is_deleted: false
  })

  sofa.images.attach(io: File.open("db/image/sofa/sofa#{i+1}_1.webp"), filename: sofa.name)
  sofa.images.attach(io: File.open("db/image/sofa/sofa#{i+1}_2.webp"), filename: sofa.name)
  sofa.images.attach(io: File.open("db/image/sofa/sofa#{i+1}_3.webp"), filename: sofa.name)
  sofa.images.attach(io: File.open("db/image/sofa/sofa#{i+1}_4.webp"), filename: sofa.name)
  sofa.images.attach(io: File.open("db/image/sofa/sofa#{i+1}_5.webp"), filename: sofa.name)
end

bed_category = Category.find_by(name: "Bed")
2.times do |i| 
  bed = Product.create!({

    name: "Comforbed bed #{i+1}",
    description: "A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.A very comforbed and stylish bed.",
    price: 33 + i*21,
    stock: 20,
    category: bed_category,
    is_deleted: false
  })

  bed.images.attach(io: File.open("db/image/bed/bed#{i+1}_1.webp"), filename: bed.name)
  bed.images.attach(io: File.open("db/image/bed/bed#{i+1}_2.webp"), filename: bed.name)
  bed.images.attach(io: File.open("db/image/bed/bed#{i+1}_3.webp"), filename: bed.name)
  bed.images.attach(io: File.open("db/image/bed/bed#{i+1}_4.webp"), filename: bed.name)
end

