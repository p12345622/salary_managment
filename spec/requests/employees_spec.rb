require 'rails_helper'

RSpec.describe "Employees", type: :request do
  let!(:employees) do
    [
      Employee.create!(full_name: "Ranit", job_title: "Engineer", country: "India", salary: 50000),
      Employee.create!(full_name: "John", job_title: "Engineer", country: "United States", salary: 70000),
      Employee.create!(full_name: "Sara", job_title: "Manager", country: "India", salary: 90000)
    ]
  end

  let(:employee_id) { employees.first.id }

  def json
    JSON.parse(response.body)
  end

  describe "GET /employees" do
    it "returns all employees" do
      get "/employees"
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(3)
    end
  end

  describe "POST /employees" do
    let(:valid_params) do
      {
        employee: {
          full_name: "shivani",
          job_title: "Designer",
          country: "India",
          salary: 45000
        }
      }
    end

    it "creates a new employee" do
      expect {
        post "/employees", params: valid_params
      }.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json["full_name"]).to eq("shivani")
    end

    it "returns error when params are invalid" do
      post "/employees", params: { employee: { full_name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /employees/:id" do
    it "shows a specific employee" do
      get "/employees/#{employee_id}"
      expect(response).to have_http_status(:ok)
      expect(json["id"]).to eq(employee_id)
    end

    it "returns 404 when employee not found" do
      get "/employees/99999"
      expect(response).to have_http_status(:not_found).or have_http_status(:unprocessable_entity)
    end
  end

  describe "PUT /employees/:id" do
    it "updates an employee" do
      put "/employees/#{employee_id}", params: { employee: { job_title: "Senior Engineer" } }
      expect(response).to have_http_status(:ok)
      expect(json["job_title"]).to eq("Senior Engineer")
    end
  end

 describe "GET /employees/:id/calculate_salary" do
    let!(:employee_india) { Employee.create(full_name: "Poonam", country: "India", job_title: "Developer", salary: 50000) }
    let!(:employee_usa)   { Employee.create(full_name: "John", country: "United States", job_title: "Manager", salary: 100000) }

    context "when employee exists" do
      it "calculates salary correctly for India" do
        get "/employees/#{employee_india.id}/calculate_salary"

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["employee_id"]).to eq(employee_india.id)
        expect(json["gross_salary"]).to eq(50000.0)
        expect(json["deduction"]).to eq(5000.0)  # 10% deduction
        expect(json["net_salary"]).to eq(45000.0)
      end

      it "calculates salary correctly for USA" do
        get "/employees/#{employee_usa.id}/calculate_salary"

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["employee_id"]).to eq(employee_usa.id)
        expect(json["gross_salary"]).to eq(100000.0)
        expect(json["deduction"]).to eq(12000.0) # 12% deduction
        expect(json["net_salary"]).to eq(88000.0)
      end
    end
  end
  describe "GET /employees/country_metrics" do
    it "returns min, max, avg salary for a country" do
      get "/employees/country_metrics", params: { country: "India" }
      expect(response).to have_http_status(:ok)
      expect(json["country"]).to eq("India")
      expect(json["avg"]).to eq("70000.0")
    end
  end

  describe "GET /employees/job_title_metrics" do
    it "returns average salary by job title" do
      get "/employees/job_title_metrics", params: { job_title: "Engineer" }
      expect(response).to have_http_status(:ok)
      expect(json["average_salary"]).to eq(60000.0)
    end
  end
end
