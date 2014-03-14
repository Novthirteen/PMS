package com.aof.component.prm.report;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

public class BackLogBean {

	private ProjectBean pb;

	private List backloglist;

	private List masterlist;

	private String cyear;

	private String cmonth;

	private Double thisyear;

	private double remainrevenue;

	private int remainmonth;

	private int pmonth;

	private Double[][] month = new Double[2][12];

	public BackLogBean() {
	}

	public Double[][] getMonth() {
		return month;
	}

	public void setMonth(Double[][] month) {
		this.month = month;
	}

	public int getPmonth() {
		return pmonth;
	}

	public void setPmonth(int pmonth) {
		this.pmonth = pmonth;
	}

	public int getRemainmonth() {
		return remainmonth;
	}

	public void setRemainmonth(int remainmonth) {
		this.remainmonth = remainmonth;
	}

	public Double getThisyear() {
		return thisyear;
	}

	public void setThisyear(Double thisyear) {
		this.thisyear = thisyear;
	}

	public void setRemainrevenue(double remainrevenue) {
		this.remainrevenue = remainrevenue;
	}

	public double getRemainrevenue() {
		return remainrevenue;
	}

	public List getBackloglist() {
		return backloglist;
	}

	public void setBackloglist(List backloglist) {
		this.backloglist = backloglist;
	}

	public String getCmonth() {
		return cmonth;
	}

	public void setCmonth(String cmonth) {
		this.cmonth = cmonth;
	}

	public String getCyear() {
		return cyear;
	}

	public void setCyear(String cyear) {
		this.cyear = cyear;
	}

	public ProjectBean getPb() {
		return pb;
	}

	public void setPb(ProjectBean pb) {
		this.pb = pb;
	}

	public void initial(ProjectBean pb, List bllist, String cyear2,
			String cmonth2, String status, List masterlist) {
		this.pb = pb;
		this.backloglist = bllist;
		this.cyear = cyear2;
		this.cmonth = cmonth2;
		this.masterlist = masterlist;

	}

	public void setBean() {

		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			int latestmonth = 0;
			int pmonth = Integer.parseInt(cmonth);
			double confirmTCV = 0;
			double draftamount = 0;
			double remain_revenue = 0;
			int remain_month = 0;
			double mTCV = 0;
			double currentamount = 0;
			double pastweightedamount = 0;
			double tybookamount = 0;

			List bllist = this.backloglist;
			Double[][] a = new Double[2][12];
			if ((bllist != null) && (bllist.size() != 0)) {
				for (int k = 0; k < bllist.size(); k++) {
					BackLog bl = (BackLog) bllist.get(k);
					if ((bl.getBl_year() == Integer.parseInt(cyear))) {
						a[0][bl.getbl_month() - 1] = new Double(bl.getAmount());
						if ((bl.getStatus().trim().equals("draft"))
								&& (bl.getbl_month() == Integer
										.parseInt(cmonth))
								&& (!((pb.getContractType()
										.equalsIgnoreCase("tm")) && (pb
										.getCAFFlag().equalsIgnoreCase("y")))))
							a[1][bl.getbl_month() - 1] = new Double(12);// means
						else
							a[1][bl.getbl_month() - 1] = new Double(22);// means
					}
					if (bl.getStatus().trim().equals("confirm")
							|| (bl.getStatus().trim().equalsIgnoreCase("draft"))) {
						if ((bl.getBl_year() == Integer.parseInt(cyear))
								&& (bl.getBl_month() <= Integer
										.parseInt(cmonth)))
							tybookamount += bl.getAmount();
					}
					if (bl.getStatus().trim().equals("confirm")
							&& (!((bl.getBl_year() == Integer.parseInt(cyear)) && (bl
									.getBl_month() == Integer.parseInt(cmonth)))))
						confirmTCV += bl.getAmount();

					if (bl.getStatus().trim().equals("draft")
							&& (!((bl.getBl_year() == Integer.parseInt(cyear)) && (bl
									.getBl_month() == Integer.parseInt(cmonth)))))
						draftamount += bl.getAmount();
					if ((bl.getBl_month() == Integer.parseInt(cmonth))
							&& (bl.getBl_year() == Integer.parseInt(cyear)))
						currentamount = (int) bl.getAmount();
					if (bl.getBl_year() == Integer.parseInt(cyear))
						latestmonth = latestmonth > bl.getBl_month() ? latestmonth
								: bl.getBl_month();

				}
				latestmonth = latestmonth + 1;
				pmonth = pmonth > latestmonth ? pmonth : latestmonth;

			}
			remain_revenue = pb.getTotalServiceValue().doubleValue() / 1000
					- confirmTCV - draftamount;
			this.setRemainrevenue(remain_revenue);

			pmonth = this.getStMonth(cyear, cmonth, pb, pmonth);
			remain_month = this.remainmonth(cyear, cmonth, pb, remain_month,
					pmonth);
			if (Integer.parseInt(cmonth) == pmonth) {// splite
				this.setRemainmonth(remain_month - 1);
				this.setPmonth(pmonth + 1);
			} else {
				this.setRemainmonth(remain_month);
				this.setPmonth(pmonth);
			}
			int covermonth = 0;
			if ((masterlist != null) && (masterlist.size() != 0)) {
				for (int i = 0; i < masterlist.size(); i++) {
					BackLogMaster master = (BackLogMaster) masterlist.get(i);
					if (master.getBlm_year() == Integer.parseInt(cyear)) {
						this.thisyear = master.getAmount();
					}
					if (master.getBlm_year() <= Integer.parseInt(cyear)) {
						pastweightedamount += master.getAmount().doubleValue();
					}
				}
			}else{
				if (thisyear == null) {
				//	if (ed_year < Integer.parseInt(cyear)) {
					//	this.thisyear = new Double(0);
				//	} else
						this.thisyear = setWeightedValue(new Double(
								pastweightedamount));
			//	}
				}
			}
			if (!((pb.getContractType().trim().equalsIgnoreCase("tm")) && (pb
					.getCAFFlag().trim().equalsIgnoreCase("y")))) {
				String myString = df.format(pb.getEndDate());
				StringTokenizer st = new StringTokenizer(myString, "-");
				int ed_year = Integer.parseInt(st.nextToken());
				int ed_month = Integer.parseInt(st.nextToken());
				if (thisyear == null) {
					if (ed_year < Integer.parseInt(cyear)) {
						this.thisyear = new Double(0);
					} else
						this.thisyear = setWeightedValue(new Double(
								pastweightedamount));
				}
				if (remain_month != 0) {
					int mark = 0;
					if (Integer.parseInt(cmonth) == pmonth)
						mark = -1;
					if (pmonth + remain_month > 13)
						covermonth = 13 - pmonth;
					else {
						covermonth = remain_month;
					}
					mTCV = (int) Math
							.round((this.thisyear.doubleValue() - tybookamount)
									/ (covermonth));
				} else if (a[1][Integer.parseInt(cmonth) - 1] == null) {
					a[0][Integer.parseInt(cmonth) - 1] = new Double(0);
//					a[0][Integer.parseInt(cmonth) - 1] = new Double(Math.round(remain_revenue));
					a[1][Integer.parseInt(cmonth) - 1] = new Double(12);// means
				}
			} else {
				if (remain_month != 0) {
					mTCV = (int) Math
							.round((this.thisyear.doubleValue() - tybookamount)
									/ (remain_month));
				}
			}

			for (int k = 0; k < 12; k++) {
				if ((a[1][k] == null)) {
					if ((k >= pmonth - 1) && (k < pmonth + remain_month - 1)) {
						a[0][k] = new Double(mTCV);
						if ((k == Integer.parseInt(cmonth) - 1)
								&& (!((pb.getContractType()
										.equalsIgnoreCase("tm")) && (pb
										.getCAFFlag().equalsIgnoreCase("y"))))) {
							a[1][k] = new Double(12);
						} else
							a[1][k] = new Double(22);
					} else {
						if (!((pb.getContractType().equalsIgnoreCase("tm")) && (pb
								.getCAFFlag().equalsIgnoreCase("y")))) {
							if (k == Integer.parseInt(cmonth) - 1){
								a[0][k] = new Double(0);
							a[1][k] = new Double(12);
							}// means
							else
							{
								a[0][k] = new Double(0);
								a[1][k] = new Double(22);// means
								}
						}
						else{
						a[0][k] = new Double(0);
						a[1][k] = new Double(22);// means
						}
						// not
					}
				}
			}
			double temp = 0;
			if ((pb.getContractType().equalsIgnoreCase("tm"))
					&& (pb.getCAFFlag().equalsIgnoreCase("y"))) {
				for (int k = 0; k < 12; k++)
					temp += a[0][k].doubleValue();
				this.thisyear = new Double(temp);
			}
			this.setMonth(a);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int remainmonth(String cyear, String cmonth, ProjectBean pb,
			int remain_month, int pmonth) {
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String myString = df.format(pb.getStartDate());
			StringTokenizer st = new StringTokenizer(myString, "-");
			int st_year = Integer.parseInt(st.nextToken());
			int st_month = Integer.parseInt(st.nextToken());

			myString = df.format(pb.getEndDate());
			st = new StringTokenizer(myString, "-");
			int ed_year = Integer.parseInt(st.nextToken());
			int ed_month = Integer.parseInt(st.nextToken());

			if ((pmonth < 13) && (pmonth > 0)) {
				st_year = Integer.parseInt(cyear);
				st_month = pmonth;
			} else if (pmonth > 12)//
			{
				return 0;
			}
			if (st_year == ed_year) {
				for (int m = st_month; m < ed_month + 1; m++)
					remain_month += 1;
			} else if ((ed_year - st_year) == 1) {
				for (int m = st_month; m < 13; m++)
					remain_month += 1;
				for (int m = 1; m < ed_month + 1; m++)
					remain_month += 1;
			} else if ((ed_year - st_year) > 1) {
				for (int m = st_month; m < 13; m++)
					remain_month += 1;
				for (int m = 1; m < ed_month + 1; m++)
					remain_month += 1;
				for (int m = 1; m < 13; m++)
					remain_month += 1;
			}
			return remain_month;
		} catch (Exception e) {
			System.out.println("error");
			return 0;
		}
	}

	public int getStMonth(String cyear, String cmonth, ProjectBean pb,
			int temppmonth) throws ParseException {
		int pmonth;
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(pb.getStartDate());
		StringTokenizer st = new StringTokenizer(myString, "-");
		int temp_st_year = Integer.parseInt(st.nextToken());
		int temp_st_month = Integer.parseInt(st.nextToken());
		Date tempdate;

		if (pb.getContractType().equalsIgnoreCase("TM")
				&& pb.getCAFFlag().equalsIgnoreCase("y")) {
			tempdate = df.parse(cyear + "-" + cmonth + "-1");
			if (this.compareDate(pb.getStartDate(), tempdate) >= 0) {
				if (Integer.parseInt(cyear) == temp_st_year)
					pmonth = temp_st_month;
				else
					pmonth = 13;
			} else if (this.compareDate(pb.getEndDate(), tempdate) <= 0)
				pmonth = 13;
			else
				pmonth = Integer.parseInt(cmonth);
		} else {
			tempdate = df.parse(cyear + "-" + temppmonth + "-1");
			if (this.compareDate(pb.getStartDate(), tempdate) > 0) {
				if (Integer.parseInt(cyear) == temp_st_year)
					pmonth = temp_st_month;
				else
					pmonth = 13;
			} else if (this.compareDate(pb.getEndDate(), tempdate) < 0)
				pmonth = 13;
			else
				pmonth = temppmonth;

		}
		return pmonth;
	}

	public int compareDate(Date date1, Date date2) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(date1);
		StringTokenizer st = new StringTokenizer(myString, "-");
		int year1 = Integer.parseInt(st.nextToken());
		int month1 = Integer.parseInt(st.nextToken());

		myString = df.format(date2);
		st = new StringTokenizer(myString, "-");
		int year2 = Integer.parseInt(st.nextToken());
		int month2 = Integer.parseInt(st.nextToken());
		if (year1 == year2) {
			if (month1 < month2)
				return -1;
			else if (month1 > month2)
				return 1;
			else
				return 0;
		} else {
			if (year1 < year2)
				return -1;
			else if (year1 > year2)
				return 1;
			else
				return 0;
		}
	}

	public Double setWeightedValue(Double past) throws ParseException {
		double remain = this.getPb().getTotalServiceValue().doubleValue()
				- past.doubleValue() * 1000;
		String myString = null;
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		myString = df.format(this.getPb().getStartDate());
		StringTokenizer st = new StringTokenizer(myString, "-");
		int st_year = Integer.parseInt(st.nextToken());
		int st_month = Integer.parseInt(st.nextToken());

		if (st_year == Integer.parseInt(cyear))
			st_month = st_month > Integer.parseInt(cmonth) ? st_month : Integer
					.parseInt(cmonth);

		myString = df.format(this.pb.getEndDate());
		st = new StringTokenizer(myString, "-");
		int ed_year = Integer.parseInt(st.nextToken());
		int ed_month = Integer.parseInt(st.nextToken());
		int covermonth = 0;
		int re_month = 0;

		if (st_year == ed_year) {
			if (Integer.parseInt(cyear) == st_year)
				return new Double(this.getPb().getTotalServiceValue()
						.doubleValue() / 1000);
			else
				return new Double(0);
		} else {
			if ((Integer.parseInt(cyear) < st_year)
					|| (Integer.parseInt(cyear) > ed_year))
				return new Double(0);
			// calculate the remain month;
			else if (Integer.parseInt(cyear) == ed_year)
				return new Double(remain / 1000);
			else if (Integer.parseInt(cyear) == st_year) {
				re_month = this.calculatemonth(pb.getStartDate(), pb
						.getEndDate());
			} else {
				re_month = this.calculatemonth(Integer.parseInt(cyear), pb
						.getEndDate());
			}

			// calculate this cover months

			if ((ed_year - st_year) == 1) {
				if (Integer.parseInt(cyear) == st_year) {
					covermonth = 13 - st_month;
				} else {
					covermonth = ed_month;
				}
			} else {
				if (Integer.parseInt(cyear) == st_year) {
					covermonth = 13 - st_month;
				} else if (Integer.parseInt(cyear) == ed_year) {
					covermonth = ed_month;
				} else
					covermonth = 12;
			}
			return new Double(((remain / re_month) * covermonth) / 1000);
		}
	}

	public int calculatemonth(Date start, Date end) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(start);
		StringTokenizer st = new StringTokenizer(myString, "-");
		int st_year = Integer.parseInt(st.nextToken());
		int st_month = Integer.parseInt(st.nextToken());

		myString = df.format(end);
		st = new StringTokenizer(myString, "-");
		int ed_year = Integer.parseInt(st.nextToken());
		int ed_month = Integer.parseInt(st.nextToken());

		int month = 0;
		if (st_year == ed_year)
			month = ed_month - st_month + 1;
		else
			month = 13 - st_month + ed_month + 12 * (ed_year - st_year - 1);

		return month;
	}

	public int calculatemonth(int st_year, Date end) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String myString = df.format(end);
		StringTokenizer st = new StringTokenizer(myString, "-");
		int ed_year = Integer.parseInt(st.nextToken());
		int ed_month = Integer.parseInt(st.nextToken());
		return (ed_month + 12 * (ed_year - st_year));

		/*
		 * int month = 0; if (st_year == ed_year) month = ed_month; else month =
		 * ed_month + 12 * (ed_year - st_year);
		 * 
		 * return month;
		 */}

}