package com.Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import com.DAO.EmployerDAO;
import com.DAO.JobSeekerDAO;
import com.Model.Employer;
import com.Model.JobSeeker;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/JobSeekerRegisterServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class JobSeekerRegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String role = req.getParameter("role");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (role == null || role.isEmpty()) {
            resp.sendRedirect("register.jsp?error=roleNotSelected");
            return;
        }

        try {
            if ("seeker".equals(role)) {
                handleSeeker(req, email, password);
            } else if ("employer".equals(role)) {
                handleEmployer(req, email, password);
            }
            // Success! Redirect to login
            resp.sendRedirect("login.jsp?msg=registrationSuccess");
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("register.jsp?error=exceptionOccurred");
        }
    }

    private void handleSeeker(HttpServletRequest req, String email, String password) throws Exception {
        // Resume upload logic
        Part resumePart = req.getPart("resume");
        String originalName = Paths.get(resumePart.getSubmittedFileName()).getFileName().toString();
        // Add UUID to prevent duplicate filenames overwriting each other
        String fileName = UUID.randomUUID().toString() + "_" + originalName;

        String uploadPath = getServletContext().getRealPath("") + File.separator + "resumes";
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        resumePart.write(uploadPath + File.separator + fileName);

        JobSeeker js = new JobSeeker();
        js.setName(req.getParameter("name"));
        js.setEmail(email);
        js.setPassword(password);
        
        // Handle potential number format issues
        String expStr = req.getParameter("experience");
        js.setExperienceYears(expStr != null && !expStr.isEmpty() ? Integer.parseInt(expStr) : 0);
        
        js.setLocation(req.getParameter("seekerLocation"));
        js.setResumePath("resumes/" + fileName);

        String[] skillIds = req.getParameterValues("skills");

        JobSeekerDAO dao = new JobSeekerDAO();
        dao.registerWithSkills(js, skillIds);
    }

    private void handleEmployer(HttpServletRequest req, String email, String password) throws Exception {
        Employer emp = new Employer();
        emp.setCompanyName(req.getParameter("companyName"));
        emp.setEmail(email);
        emp.setPassword(password);
        // Ensure this matches the 'empLocation' name in your JSP
        emp.setLocation(req.getParameter("employerLocation"));

        EmployerDAO dao = new EmployerDAO();
        dao.addEmployer(emp);
    }
}
