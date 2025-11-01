class EmployeesController < ApplicationController
	before_action :set_employee, only: %[show]
  def index
    render json: Employee.all
	end

# /employees body: {"employee": { "full_name":  "ranit", "salary": "2223.23", "country": "san", "job_title":"engineer"} } create api
  def create 
    @employee = Employee.new(employee_params)
    if @employee.save
      render json: @employee, status: :created
    else
      render json: employee.errors, status: unprocessable_entity
    end
  end
# employees/:id -> here need to show with perticuler id.   
  def show 
    render json: @employee
  end

	private 

  def set_employee
    @employee = Employee.find(params[:id])
  end

	def employee_params
    params.require(:employee).permit(:full_name, :country, :job_title, :salary)
	end
end
