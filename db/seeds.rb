# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
  
# coding: utf-8
Status.create(:key => 'UNPAID', :japanese => '未返済', :english => 'Unpiad')
Status.create(:key => 'PAID', :japanese => '返済済', :english => 'Paid')
Status.create(:key => 'UNREAD', :japanese => '未読', :english => 'Unread')
Status.create(:key => 'DELETED', :japanese => '削除済', :english => 'Deleted')
Status.create(:key => 'ACCEPTED', :japanese => '合意済', :english => 'Accepted')
