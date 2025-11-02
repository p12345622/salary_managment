class EmployeesController < ApplicationController
	before_action :set_employee, only: [:show, :update, :destroy]
  
  def index
    render json: Employee.all
	end

# /employees body: {"employee": { "full_name":  "ranit", "salary": "2223.23", "country": "san", "job_title":"engineer"} } create api
  def create 
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end
# employees/:id -> here need to show with perticuler id.   
  def show #employees/:id
    render json: @employee
  end

  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end 

  def destroy
    @employee.destroy
    render json: no_content
  end

  #calculate salary 
  def calculate_salary #employees/calculate_salary
    # byebug
    @employee = Employee.find(params[:id])
    return render json: { error: "Employee not found" }, status: :not_found unless @employee
    gross = @employee.salary.to_f
    deduction_rate = 
    case @employee.country.downcase
      when "india" then 0.10
      when "united states", "usa" then 0.12
      else 0
    end
    net_salary = gross - (gross * deduction_rate)
    render json: {
      employee_id:@employee.id,
      gross_salary:gross,
      deduction: (gross * deduction_rate),
      net_salary: net_salary
    }
  end

  def country_metrics
    employee = Employee.where(country: params[:country])
    salary = employee.pluck(:salary)
    render json: {
      country: params[:country],
      min: salary.min,
      max: salary.max,
      avg: (salary.sum / salary.size.to_f).round(2)
    }
  end
# get /employees/job_title_metrics?job_title=Engineer
  def job_title_metrics
    employees = Employee.where(job_title: params[:job_title])
    avg = employees.average(:salary).to_f.round(2)
    render json: { job_title: params[:job_title], average_salary: avg }
  end

	private 

  def set_employee
    @employee = Employee.find(params[:id])
  end

	def employee_params
    params.require(:employee).permit(:full_name, :country, :job_title, :salary)
	end
end
