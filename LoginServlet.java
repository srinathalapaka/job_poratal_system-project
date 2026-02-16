package com.Controller;


import java.io.IOException;

import com.DAO.AdminDAO;
import com.DAO.EmployerDAO;
import com.DAO.JobSeekerDAO;
import com.Model.Admin;
import com.Model.Employer;
import com.Model.JobSeeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        HttpSession session = req.getSession();

        try {
            switch (role) {

                case "admin":
                    AdminDAO adao = new AdminDAO();
                    Admin admin = adao.login(email, password);
                    if (admin != null) {
                        session.setAttribute("admin", admin);
                        resp.sendRedirect("AdminDashboard.jsp");
                        return;
                    }
                    break;

                case "employer":
                    EmployerDAO edao = new EmployerDAO();
                    Employer emp = edao.login(email, password);
                    if (emp != null) {
                        session.setAttribute("employer", emp);
                        resp.sendRedirect("EmployerDashboard.jsp");
                        return;
                    }
                    break;

                case "jobseeker":
                    JobSeekerDAO jsdao = new JobSeekerDAO();
                    JobSeeker js = jsdao.login(email, password);
                    if (js != null) {
                        session.setAttribute("jobseeker", js);
                        resp.sendRedirect("JobseekerDashboard.jsp");
                        return;
                    }
                    break;
            }
            
           
            req.setAttribute("error", "Invalid Email or Password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
