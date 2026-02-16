package com.Controller;

import java.io.IOException;

import com.DAO.EmployerDAO;
import com.Model.Employer;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/AddEmployer")
public class AddEmployerServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Employer emp = new Employer();
        emp.setCompanyName(request.getParameter("companyName"));
        emp.setEmail(request.getParameter("email"));
        emp.setPassword(request.getParameter("password"));
        emp.setLocation(request.getParameter("location"));

        try {
			new EmployerDAO().addEmployer(emp);
		} catch (Exception e) {
			 
			e.printStackTrace();
		}
        response.sendRedirect("AdminDashboard.jsp");
    }
}


