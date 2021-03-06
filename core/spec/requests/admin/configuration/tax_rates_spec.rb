require 'spec_helper'

describe "Tax Rates" do
  let!(:tax_rate) { create(:tax_rate, :calculator => stub_model(Spree::Calculator)) }

  before do
    visit spree.admin_path
    click_link "Configuration"
  end

  # Regression test for #535
  it "can see a tax rate in the list if the tax category has been deleted" do
    tax_rate.tax_category.mark_deleted!
    lambda { click_link "Tax Rates" }.should_not raise_error
    within("table tbody td:nth-child(2)") do
      page.should have_content("Not Available")
    end
  end

  # Regression test for #1422
  it "can create a new tax rate" do
    click_link "Tax Rates"
    click_link "New Tax Rate"
    fill_in "Rate", :with => "0.05"
    click_button "Create"
    page.should have_content("Tax Rate has been successfully created!")
  end
end
