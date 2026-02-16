<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | CareerHub</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #0a66c2;
            --bg-color: #f3f2ef;
            --card-shadow: 0 12px 24px rgba(0, 0, 0, 0.08);
        }

        body {
            background-color: var(--bg-color);
            font-family: 'Plus Jakarta Sans', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        .login-container {
            width: 100%;
            max-width: 450px;
            padding: 15px;
        }

        .card {
            border: none;
            border-radius: 16px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .card-header {
            background: white;
            border-bottom: none;
            padding: 40px 40px 20px;
        }

        .form-control {
            padding: 12px 15px;
            border-radius: 8px;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(10, 102, 194, 0.1);
        }

        .btn-login {
            background: var(--primary-color);
            border: none;
            padding: 12px;
            font-weight: 700;
            border-radius: 8px;
            transition: all 0.3s;
        }

        .btn-login:hover {
            background: #004182;
            transform: translateY(-1px);
        }

        .role-select {
            background-color: #f8f9fa;
            font-weight: 600;
            cursor: pointer;
        }

        .brand-logo {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="alert alert-danger alert-dismissible fade show mb-4 border-0 shadow-sm" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="card">
        <div class="card-header text-center">
            <div class="brand-logo">
                <i class="bi bi-rocket-takeoff-fill"></i>
            </div>
            <h3 class="fw-bold">Welcome Back</h3>
            <p class="text-muted small">Enter your credentials to access your account</p>
        </div>

        <div class="card-body px-4 pb-4">
            <form action="LoginServlet" method="post">
                
                <div class="mb-4">
                    <label class="form-label small fw-bold">Login As</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-person-badge"></i></span>
                        <select name="role" class="form-select role-select">
                            <option value="jobseeker">Job Seeker</option>
                            <option value="employer">Employer</option>
                            <option value="admin">Administrator</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-bold">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>

                <div class="mb-4">
                    <div class="d-flex justify-content-between">
                        <label class="form-label small fw-bold">Password</label>
                        <a href="#" class="text-decoration-none small fw-bold text-primary">Forgot?</a>
                    </div>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary btn-login w-100 mb-3 shadow-sm">
                    Sign In <i class="bi bi-arrow-right-short"></i>
                </button>
            </form>

            <div class="text-center mt-3">
                <p class="text-muted small">Don't have an account? 
                    <a href="register.jsp" class="text-primary fw-bold text-decoration-none">Join now</a>
                </p>
            </div>
        </div>
    </div>
</div>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>