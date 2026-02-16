<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.Model.JobSeeker"%>

<%
JobSeeker JS = (JobSeeker) request.getAttribute("jobSeeker");
if (JS == null) {
    out.println("<div class='container mt-5 alert alert-danger'>Job Seeker not found</div>");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Candidate Profile | <%= JS.getName() %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-blue: #0a66c2;
            --light-bg: #f3f2ef;
        }

        body { 
            background: var(--light-bg); 
            font-family: 'Inter', sans-serif;
            color: #1d1d1d;
        }

        .navbar {
            background: #ffffff !important;
            border-bottom: 1px solid #e0e0e0;
            padding: 0.75rem 1.5rem;
        }

        .profile-container {
            max-width: 900px;
            margin: 30px auto;
        }

        .profile-card {
            background: white;
            border: none;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 0 1px rgba(0,0,0,0.08);
        }

        .profile-header-banner {
            height: 120px;
            background: linear-gradient(to right, #0a66c2, #004182);
        }

        .profile-avatar-wrapper {
            margin-top: -60px;
            padding: 0 40px;
        }

        .avatar-circle {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 4px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            font-size: 3rem;
            color: var(--primary-blue);
        }

        .info-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 700;
            color: #666;
        }

        .info-value {
            font-size: 1rem;
            font-weight: 500;
            color: #1d1d1d;
        }

        .section-title {
            border-bottom: 2px solid #f3f2ef;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-weight: 700;
            color: var(--primary-blue);
        }

        .btn-back {
            color: #666;
            text-decoration: none;
            transition: color 0.2s;
        }
        .btn-back:hover { color: var(--primary-blue); }
        
        
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container-fluid">
        <a href="javascript:history.back()" class="btn-back fw-bold">
            <i class="bi bi-arrow-left me-2"></i> Back to Dashboard
        </a>
        <div class="ms-auto">
            <a href="EmployerLogoutServlet" class="btn btn-outline-danger btn-sm px-3">
                <i class="bi bi-box-arrow-right me-1"></i> Logout
            </a>
        </div>
    </div>
</nav>

<div class="container profile-container">
    <div class="profile-card">
        <div class="profile-header-banner"></div>
        <div class="profile-avatar-wrapper d-flex align-items-end justify-content-between">
            <div class="avatar-circle bg-white">
                <i class="bi bi-person-badge"></i>
            </div>
            <div class="pb-2">
                <a href="<%= JS.getResumePath() %>" target="_blank" class="btn btn-primary px-4 fw-bold shadow-sm">
                    <i class="bi bi-file-earmark-pdf me-2"></i> Download Resume
                </a>
            </div>
        </div>

        <div class="card-body p-4 p-md-5">
            <div class="mb-4">
                <h2 class="fw-bold mb-1"><%= JS.getName() %></h2>
                <p class="text-muted"><i class="bi bi-geo-alt me-1"></i> <%= JS.getLocation() %> • Candidate ID: #<%= JS.getJobSeekerId() %></p>
            </div>

            <div class="row mt-4">
                <div class="col-md-12">
                    <h5 class="section-title">Professional Overview</h5>
                </div>
                
                <div class="col-md-6 mb-4">
                    <div class="p-3 border rounded-3 bg-light">
                        <div class="info-label">Email Address</div>
                        <div class="info-value"><%= JS.getEmail() %></div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="p-3 border rounded-3 bg-light">
                        <div class="info-label">Experience Level</div>
                        <div class="info-value"><%= JS.getExperienceYears() %> Years of Experience</div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="p-3 border rounded-3 bg-light">
                        <div class="info-label">Current Location</div>
                        <div class="info-value"><%= JS.getLocation() %></div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="p-3 border rounded-3 bg-light">
                        <div class="info-label">Resume Status</div>
                        <div class="info-value text-success">
                            <i class="bi bi-check-circle-fill me-1"></i> Document Verified
                        </div>
                    </div>
                </div>
            </div>

            <div class="alert alert-info border-0 bg-primary-subtle text-primary mt-3">
                <i class="bi bi-lightbulb me-2"></i> 
                <strong>Tip for Employer:</strong> You can shortlist this candidate directly from your dashboard to initiate an interview.
            </div>
        </div>
    </div>
    
    <div class="text-center mt-4 text-muted small">
        &copy; 2026 CareerHub Employer Portal. All rights reserved.
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>