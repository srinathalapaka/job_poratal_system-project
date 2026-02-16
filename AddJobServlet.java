package com.Controller;

import java.io.IOException;

import com.DAO.JobDAO;
import com.Model.Job;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/AddJobServlet")
public class AddJobServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		if (session.getAttribute("userId") == null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		Job j = new Job();
		j.setEmployerId((Integer) session.getAttribute("userId"));
		j.setTitle(request.getParameter("title"));
		j.setLocation(request.getParameter("location"));
		j.setDescription(request.getParameter("description"));
		j.setSalaryMin(Double.parseDouble(request.getParameter("salaryMin")));
		j.setSalaryMax(Double.parseDouble(request.getParameter("salaryMax")));
		
		JobDAO dao = new JobDAO();
		try {
			dao.addJob(j);
		} catch (Exception e) {
			e.printStackTrace();
		}
			
		response.sendRedirect("EmployerDashboard.jsp");
	}

}
