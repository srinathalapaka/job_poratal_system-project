package com.Controller;

import java.io.IOException;

import com.DAO.EmployerDAO;
import com.Model.Employer;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/EditEmployer")
public class EditEmployerServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Employer emp = new Employer();
        emp.setEmployerId(Integer.parseInt(request.getParameter("id")));
        emp.setCompanyName(request.getParameter("companyName"));
        emp.setEmail(request.getParameter("email"));
        emp.setLocation(request.getParameter("location"));

        try {
			new EmployerDAO().updateEmployer(emp);
		} catch (Exception e) {			 
			e.printStackTrace();
		}
        response.sendRedirect("AdminDashboard.jsp");
    }
}


