require 'rails_helper'

RSpec.describe "Employees", type: :request do
  describe "GET /employees" do
    it "returns all employees" do
      Employee.create!(full_name: "John", job_title: "Engineer", country: "India", salary: 50000)
      get "/employees"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "POST /employees" do
    it "creates an employee" do
      post "/employees", params: { employee: { full_name: "Jane", job_title: "Designer", country: "USA", salary: 70000 } }
      expect(response).to have_http_status(:created)
    end
  end
end
