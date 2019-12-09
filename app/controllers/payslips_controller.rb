class PayslipsController < ApplicationController
  before_action :is_admin?
  layout "payslip", only: [:show]

  def index
    @payslips = Payslip.select(:id,:pay_id,:month,:year).where(user_id: params[:id])
    @detail = Detail.find(params[:id])
  end

  def new
    @payslip = Payslip.new
    @detail = Detail.find(params[:id])
    session[:id] = @detail.id
  end

  def create
    @payslip = Payslip.new(pay_params)
    @detail = Detail.find(session[:id])
    @per = Percentage.find(1)
    @payslip.user_id = @detail.id
    @payslip.pay_id = @detail.empid << @payslip.month.to_s.rjust(2,"0") << @payslip.year.to_s
    @payslip.hra = @payslip.basic * (@per.hra_per/100)
    @payslip.cca = @payslip.basic * (@per.cca_per/100)
    @payslip.spl_all = @payslip.basic * (@per.spl_all_per/100)
    @payslip.trans_all = @payslip.basic * (@per.trans_all_per/100)
    @payslip.lop = (@payslip.basic/30)*@payslip.days
    @payslip.gross = @payslip.basic+@payslip.hra+@payslip.cca+@payslip.spl_all+@payslip.trans_all+@payslip.reimb
    @payslip.p_tax = find_ptax(@payslip.gross)
    @payslip.net = @payslip.gross - (@payslip.lop+@payslip.deduction+@payslip.p_tax)
    @payslip.ctc = @payslip.gross*12
    if @payslip.save
      redirect_to payslip_path(@payslip)
    else
      render "new"
    end
  end

  def show
    @payslip = Payslip.find(params[:id])
    @detail = Detail.find_by(user_id: @payslip.user_id)
    @account = Account.find_by(user_id: @payslip.user_id)
    temp = {'1':'JAN','2':'FEB','3':'MAR'}
    @mon = temp[@payslip.month.to_s]
  end

  private

  def pay_params
    params.require(:payslip).permit(:pay_id,:user_id,:basic,:hra,:cca,:spl_all,:trans_all,:reimb,:lop,:deduction,:p_tax,:gross,:net,:ctc,:days,:month,:year)
  end

  def find_ptax(gross)
    if gross>=15000
      200
    else
      0
    end
  end
end
