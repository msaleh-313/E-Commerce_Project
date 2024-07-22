require 'rails_helper'

RSpec.describe Category, type: :model do
    it 'is valid with a unique name and description' do

      categoryDummy=Category.new(name: 'Pottery', description: 'Pottery test description')
      categoryDummy.save
      category_test=Category.new(name: 'Pottery', description: 'Pottery test description')      
      # expect(category).to be_valid checks whether the category instance passes all the validations
      #  defined in the Category model.
      expect(category_test).to be_valid
    end

    it 'is invalid without a name ' do
      category = Category.new(name: nil ,description: 'description lorem ipsum delor ')
      expect(category).not_to be_valid
    end

    it 'is invalid without a description' do
        category=Category.new(name: 'Garments', description: nil)
        expect(category).not_to be_valid

        # good Practice 
        expect(category.errors[:description]).to include("can't be blank")
    end

    it 'is invalid without name and without description' do
      category=Category.create(name: nil,description: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("cant be blank")
      expect(category.errors[:description]).to include("can't be blank")
    end

    

end