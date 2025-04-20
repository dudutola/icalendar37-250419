# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning database..."
Event.destroy_all

puts "Creating events"
Event.create!(
  title: "Demo Day",
  description: "LeWagon presentations",
  starts_at: DateTime.new(2025, 4, 22, 10),
  ends_at: DateTime.new(2025, 4, 22, 18),
  address: "Rua do Comércio, 150 Lisboa, Portugal"
)

Event.create!(
  title: "Doctor Appointment",
  description: "General check-up",
  starts_at: DateTime.new(2025, 5, 19, 8),
  ends_at: DateTime.new(2025, 5, 19, 10),
  address: "Av. da Liberdade, 99-150 Lisboa, Portugal"
)

puts "Events created"
