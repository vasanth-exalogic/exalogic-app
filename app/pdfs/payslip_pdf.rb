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
    table_data = [[{ content: "Exalogic Solutions", colspan: 4, align: :center, :font_style => :bold} ],
          [{ content: "22, Ganganagar, 1st Main Road, Bangalore - 560032, India", colspan: 4, align: :center, :font_style => :bold}],
          [{ content: @month<<" - "<<@payslip.year.to_s<<" - Payslip", colspan: 4, align: :center, :font_style => :bold}],]
    table(table_data, :width=>540, :cell_style => {:border_width => 0})
  end

  def line_items
    move_down 20
    table_data = [[{content: "Employee ID", :font_style => :bold},@detail.empid,{content: "Name", :font_style => :bold},@account.accname],
                  [{content: "Department", :font_style => :bold},@detail.department,{content: "Designation", :font_style => :bold},@detail.designation],
                  [{content: "Date of Joining", :font_style => :bold},@detail.doj,{content: "Number of Days", :font_style => :bold},@payslip.no_days],
                  [{content: "Account Number", :font_style => :bold},@account.accno,{content: "Bank", :font_style => :bold},@account.bank<<", "<<@account.branch],
                  [{content: "IFSC Code", :font_style => :bold},@account.ifsc,nil,nil]]
    table(table_data, :width=>540, :cell_style => {:border_width => 0})
  end

  def line_items_2
    move_down 30
    table_data = [[{content: "EARNINGS", align: :center, :font_style => :bold},{content: "AMOUNT", align: :center, :font_style => :bold},{content: "DEDUCTIONS", align: :center, :font_style => :bold},{content: "AMOUNT", align: :center, :font_style => :bold}],
                  ["Basic Pay",{content: "#{@payslip.basic.to_i}", align: :center},"Professional Tax",{content: "#{@payslip.p_tax.to_i}", align: :center}],
                  ["HRA",{content: "#{@payslip.hra.to_i}", align: :center},"Loss of Pay",{content: "#{@payslip.lop.to_i}", align: :center}],
                  ["CCA",{content: "#{@payslip.cca.to_i}", align: :center},"Deductions",{content: "#{@payslip.deduction.to_i}", align: :center}],
                  ["Special Allowance",{content: "#{@payslip.spl_all.to_i}", align: :center},nil,nil],
                  ["Transport Allowance",{content: "#{@payslip.trans_all.to_i}", align: :center},nil,nil],
                  ["Reimbursments",{content: "#{@payslip.reimb.to_i}", align: :center},nil,nil],
                  [{content: "Total Earnings", :font_style => :bold},{content: "#{@payslip.gross.to_i}", align: :center},{content: "Total Deductions", :font_style => :bold},{content: "#{(@payslip.deduction+@payslip.lop+@payslip.p_tax).to_i}", align: :center}],
                  [nil,nil,{content: "Net Pay", :font_style => :bold},{content: "#{@payslip.net.to_i}", align: :center}]]
    table(table_data, :width=>540)
  end

  def line_items_3
    move_down 30
    text "Net Pay (in words) : "  << @payslip.net.humanize.capitalize << " rupees only"
    move_down 30
    text "***This is a system generated payslip and does not require signature", align: :center
  end
end
