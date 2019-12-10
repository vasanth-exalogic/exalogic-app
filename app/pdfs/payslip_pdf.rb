class PayslipPdf < Prawn::Document
  def initialize(payslip,month)
    super(top_margin: 50)
    @payslip = payslip
    @detail = Detail.find_by(user_id: @payslip.user_id)
    @account = Account.find_by(user_id: @payslip.user_id)
    @month = month
    line_items_1
    line_items
    line_items_2
    line_items_3
  end

  def payslip_number
    text "Payslip \##{@payslip.pay_id}", size: 30, style: :bold
  end

  def line_items_1
    image "#{Rails.root}/app/assets/images/exalogic.png", :width => 120
    move_down 10
    table_data = [[{ content: "Exalogic Solutions", colspan: 4, align: :center } ],
          [{ content: "22, Ganganagar, 1st Main Road, Bangalore - 560032, India", colspan: 4, align: :center }],
          [{ content: @month<<" - "<<@payslip.year.to_s<<" - Payslip", colspan: 4, align: :center  }],]
    table(table_data, :width=>540, :cell_style => {:border_width => 0})
  end

  def line_items
    move_down 20
    table_data = [["Emplyee ID",@detail.empid,"Name",@account.accname],
                  ["Department",@detail.department,"Designation",@detail.designation],
                  ["Date of Joining",@detail.doj,"Account Number",@account.accno],
                  ["Bank",@account.bank<<", "<<@account.branch,"IFSC Code",@account.ifsc]]
    table(table_data, :width=>540, :cell_style => {:border_width => 0})
  end

  def line_items_2
    move_down 30
    table_data = [[{content: "EARNINGS", align: :center},{content: "AMOUNT", align: :center},{content: "DEDUCTIONS", align: :center},{content: "AMOUNT", align: :center}],
                  ["Basic Pay",@payslip.basic.to_i,"Professional Tax",@payslip.p_tax.to_i],
                  ["HRA",@payslip.hra.to_i,"Loss of Pay",@payslip.lop.to_i],
                  ["CCA",@payslip.cca.to_i,"Deductions",@payslip.deduction.to_i],
                  ["Special Allowance",@payslip.spl_all.to_i,nil,nil],
                  ["Transport Allowance",@payslip.trans_all.to_i,nil,nil],
                  ["Reimbursments",@payslip.reimb.to_i,nil,nil],
                  ["Total Earnings",@payslip.gross.to_i,"Total Deductions",(@payslip.deduction+@payslip.lop+@payslip.p_tax).to_i],
                  [nil,nil,"Net Pay",@payslip.net.to_i]]
    table(table_data, :width=>540)
  end

  def line_items_3
    move_down 30
    text "Net Pay (in words) : "  << @payslip.net.humanize.capitalize << " rupees only"
    move_down 30
    text "***This is a system generated payslip and does not require signature"
  end
end
