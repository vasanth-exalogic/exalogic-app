class PayslipsController < ApplicationController
  before_action :is_admin?
  layout "payslip", only: [:show]

  def index
    @payslips = Payslip.select(:id,:pay_id,:month,:year, :net).where(user_id: params[:id])
    @detail = Detail.find_by(user_id: params[:id])
  end

  def new
    @payslip = Payslip.new
    @detail = Detail.find_by(user_id: params[:id])
    session[:id] = @detail.id
  end

  def create
    @error
    @payslip = Payslip.new(pay_params)
    @detail = Detail.find(session[:id])
    @per = Percentage.find(1)
    @payslip.user_id = @detail.user_id
    @payslip.pay_id = @detail.empid << @payslip.month.to_s.rjust(2,"0") << @payslip.year.to_s
    @payslip.basic = (@payslip.gross / (1+(@per.hra_per/100)+(@per.cca_per/100)+(@per.spl_all_per/100)+(@per.trans_all_per/100))).to_i
    @payslip.hra = (@payslip.basic * (@per.hra_per/100)).to_i
    @payslip.cca = (@payslip.basic * (@per.cca_per/100)).to_i
    @payslip.spl_all = (@payslip.basic * (@per.spl_all_per/100)).to_i
    @payslip.trans_all = (@payslip.basic * (@per.trans_all_per/100)).to_i
    @payslip.lop = ((@payslip.gross/30)*@payslip.days).to_i
    @payslip.p_tax = find_ptax(@payslip.gross)
    @payslip.gross = @payslip.gross+@payslip.reimb
    @payslip.net = (@payslip.gross - (@payslip.lop+@payslip.deduction+@payslip.p_tax)).to_i
    @payslip.basic = @payslip.basic + (@payslip.gross-(@payslip.basic+@payslip.hra+@payslip.cca+@payslip.spl_all+@payslip.trans_all))
    @payslip.ctc = @payslip.gross*12
    if @payslip.year == (@detail.doj.strftime("%Y").to_i)
      if @payslip.month >= (@detail.doj.strftime("%m").to_i)
        if @payslip.save
          redirect_to payslip_path(@payslip)
        else
          render "new"
        end
      else
        @error = "Month should be within Date of Joining"
        render "new"
      end
    else
      render "new"
    end
  end

  def show
    @payslip = Payslip.find(params[:id])
    @detail = Detail.find_by(user_id: @payslip.user_id)
    @account = Account.find_by(user_id: @payslip.user_id)
    @temp = @payslip.month.to_i.humanize
		dict = {"one" => "January", "two" => "Febraury", "three" => "March", "four" => "April", "five" => "May", "six" => "June", "seven" => "July", "eight" => "August", "nine" => "September", "ten" => "October", "eleven" => "November", "twelve" => "December"}
		@temp = dict[@temp]
    respond_to do |format|
      format.html
      format.pdf do
        pdf = PayslipPdf.new(@payslip,@temp)
        send_data pdf.render, filename: "payslip_#{@payslip.id}.pdf", type: "application/pdf"

      end
    end
  end

  def download

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
