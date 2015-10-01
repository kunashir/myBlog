require 'spec_helper'

describe "integration tests" do
  let(:user) { FactoryGirl.create :user }
  let(:tr) {FactoryGirl.create :transportation}

  describe "check rules" do
    before(:each) do
      #@user = FactoryGirl.create(:user)
      login(user, 'password')
    end

    describe "for non-manager" do
      it "should not successful to new order " do
        # login(user, 'password')
        visit new_transportation_path
        expect(page).to have_content 'Нет прав для данного действия!'
      end

      xit "should not successful to create order " do
        # login(user, 'password')
        visit transportations_path
        puts page.html
        puts csrf_meta_tag
        param = {"transportation"=>
          {"num"=>"5556532111", "date"=>"2014-07-18", "time"=>"2000-01-01 09:00:00.000000",
            "area_id"=>"1", "client_id"=>"2", "city_id"=>"26", "comment"=>"", "weight"=>"20",
            "volume"=>"59", "carcase"=>"тент", "start_sum"=>"44800", "step"=>"500",
            "complex_direction"=>"0", "extra_pay"=>"0", "cur_sum"=>"", "company_id"=>""}
        }
        page.driver.post(transportations_path, { :params => param })
        expect(page).to have_content 'Нет прав для данного действия!'
      end
    end

    describe "for block user" do
      before (:each) do
        user.is_block = true
        user.save
      end

      it "don't allow do rate" do
        visit do_rate_transportation_path(tr)
        expect(page).to have_content "У Вас нет прав для просмотра заявок"
      end

      it "don't allow do spec rate" do
        visit do_spec_rate_transportation_path(tr)
        expect(page).to have_content "У Вас нет прав для просмотра заявок"
      end
    end


  end
end