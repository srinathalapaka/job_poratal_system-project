<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.Model.*,com.DAO.SkillDAO"%>
<%
    SkillDAO skillDao = new SkillDAO();
    List<Skill> allSkills = skillDao.getAllSkills();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join CareerHub | Create Your Professional Account</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

   <style>
    /* 1. Base Variables & Layout */
    :root { 
        --primary-color: #0a66c2; 
        --bg-color: #f3f2ef; 
        --input-focus: rgba(10, 102, 194, 0.1);
        --border-color: #dee2e6;
    }

    body { 
        background-color: var(--bg-color); 
        font-family: 'Plus Jakarta Sans', sans-serif; 
        color: #1d1d1d;
    }
    
    .registration-container { max-width: 650px; margin: 40px auto; }
    
    /* 2. Card & Header */
    .card { 
        border: none; 
        border-radius: 16px; 
        box-shadow: 0 12px 24px rgba(0, 0, 0, 0.08); 
    }
    
    .card-header { 
        background: white; 
        border-bottom: 1px solid #eee; 
        padding: 30px; 
        position: relative; 
    }
    
    .header-login-btn { 
        position: absolute; 
        top: 20px; 
        right: 20px; 
    }

    /* 3. Role Switcher (Sliding Toggle Look) */
    .role-toggle-container { 
        background: #eef2f6; 
        padding: 6px; 
        border-radius: 12px; 
        display: flex; 
        gap: 5px; 
    }
    
    .role-option { flex: 1; }
    
    .role-option input { display: none; }
    
    .role-option label { 
        display: block; 
        text-align: center; 
        padding: 10px; 
        border-radius: 8px; 
        cursor: pointer; 
        font-weight: 600; 
        color: #5e6d7c;
        transition: all 0.3s ease;
    }
    
    .role-option input:checked + label { 
        background: white; 
        color: var(--primary-color); 
        box-shadow: 0 4px 8px rgba(0,0,0,0.05); 
    }

    /* 4. Integrated Search Skills Dropdown */
    .skills-dropdown {
        position: relative;
        width: 100%;
    }

    .dropdown-search-field {
        padding-right: 40px !important;
        cursor: text;
        border-radius: 8px;
        border: 1px solid var(--border-color);
        padding: 10px 15px;
        width: 100%;
    }

    .dropdown-search-field:focus {
        box-shadow: 0 0 0 0.25rem var(--input-focus);
        border-color: var(--primary-color);
        outline: none;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        width: 100%;
        max-height: 250px;
        overflow-y: auto;
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        margin-top: 5px;
        z-index: 1000;
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        scrollbar-width: thin;
    }

    .dropdown-content.show { display: block; }

    .skill-item {
        padding: 10px 15px;
        border-bottom: 1px solid #f8f9fa;
        display: flex;
        align-items: center;
        transition: background 0.2s;
        cursor: pointer;
    }

    .skill-item:hover { background: #f0f7ff; }

    .skill-item input { 
        margin-right: 12px; 
        transform: scale(1.2); 
        cursor: pointer; 
    }

    .skill-item label { 
        cursor: pointer; 
        width: 100%; 
        margin: 0; 
        font-size: 0.9rem; 
        color: #444;
    }

    /* 5. Selected Skill Tags */
    .skill-tag {
        background: #e7f3ff;
        color: var(--primary-color);
        padding: 4px 12px;
        border-radius: 50px;
        font-size: 0.75rem;
        font-weight: 600;
        border: 1px solid #bbdefb;
        display: inline-flex;
        align-items: center;
        animation: fadeIn 0.2s ease-in;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(5px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 6. Form Elements & Buttons */
    .form-label { font-size: 0.85rem; margin-bottom: 6px; }

    .form-control:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 0.25rem var(--input-focus);
    }

    .btn-submit { 
        background: var(--primary-color); 
        border: none; 
        padding: 14px; 
        font-weight: 700; 
        border-radius: 10px; 
        color: white;
        transition: all 0.3s;
    }

    .btn-submit:hover {
        background: #004182;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(10, 102, 194, 0.3);
    }

    .btn-outline-primary {
        border-color: var(--primary-color);
        color: var(--primary-color);
        border-radius: 8px;
    }
</style>
</head>
<body>

<div class="container registration-container">
    <div class="card shadow">
        <div class="card-header text-center">
            <div class="header-login-btn">
                <a href="login.jsp" class="btn btn-outline-primary btn-sm fw-bold">Login</a>
            </div>
            <i class="bi bi-briefcase-fill text-primary mb-2" style="font-size: 2rem;"></i>
            <h3 class="fw-bold">Join CareerHub</h3>
        </div>

        <div class="card-body p-4 p-md-5 bg-white">
            <form action="JobSeekerRegisterServlet" method="post" enctype="multipart/form-data">
                
                <div class="mb-4">
                    <div class="role-toggle-container">
                        <div class="role-option">
                            <input type="radio" name="role" id="roleSeeker" value="seeker" checked onchange="toggleForm()">
                            <label for="roleSeeker">Job Seeker</label>
                        </div>
                        <div class="role-option">
                            <input type="radio" name="role" id="roleEmployer" value="employer" onchange="toggleForm()">
                            <label for="roleEmployer">Employer</label>
                        </div>
                    </div>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small fw-bold">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                </div>

                <div id="seekerFields">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Full Name</label>
                        <input type="text" name="name" class="form-control">
                    </div>

                  <div class="mb-3">
    <label class="form-label small fw-bold d-flex justify-content-between">
        Professional Skills
        <span id="skillCountBadge" class="badge bg-primary rounded-pill" style="display:none;">0</span>
    </label>
    
    <div class="skills-dropdown">
        <div class="position-relative">
            <input type="text" 
                   id="skillSearchInput" 
                   class="form-control dropdown-search-field" 
                   placeholder="Search and select skills..." 
                   onclick="showDropdown()" 
                   onkeyup="filterSkills()" 
                   autocomplete="off">
            <i class="bi bi-chevron-down position-absolute top-50 end-0 translate-middle-y me-3 text-muted" style="pointer-events: none;"></i>
        </div>

        <div class="dropdown-content" id="myDropdown">
            <% if (allSkills != null) { 
                for (Skill s : allSkills) { %>	
                <div class="skill-item">
                    <input type="checkbox" name="skills" value="<%=s.getSkillId()%>" id="sk_<%=s.getSkillId()%>" onchange="updateLabel()">
                    <label for="sk_<%=s.getSkillId()%>"><%=s.getSkillName()%></label>
                </div>
            <% } } %>
            <div id="noResults" class="p-3 text-muted small text-center" style="display:none;">No skills found.</div>
        </div>
    </div>
    <div id="selectedSkillsPreview" class="mt-2 d-flex flex-wrap gap-1"></div>
</div>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Experience (Years)</label>
                            <input type="number" name="experience" class="form-control" value="0">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Location</label>
                            <input type="text" name="seekerLocation" class="form-control">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold">Upload Resume (PDF)</label>
                        <input type="file" name="resume" class="form-control" id="resumeInput">
                    </div>
                </div>

                <div id="employerFields" style="display: none;">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Company Name</label>
                        <input type="text" name="companyName" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">HQ Location</label>
                        <input type="text" name="employerLocation" class="form-control">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-submit w-100 text-white mt-2">Create Account</button>
            </form>
        </div>
    </div>
</div>

<script>
    // 1. Toggle Seeker/Employer fields
    function toggleForm() {
        const isSeeker = document.getElementById('roleSeeker').checked;
        const seekerFields = document.getElementById('seekerFields');
        const employerFields = document.getElementById('employerFields');
        const resumeInput = document.getElementById('resumeInput');

        if (seekerFields && employerFields) {
            seekerFields.style.display = isSeeker ? 'block' : 'none';
            employerFields.style.display = isSeeker ? 'none' : 'block';
            if(resumeInput) resumeInput.required = isSeeker;
        }
    }

    // 2. Dropdown Visibility
    function showDropdown() {
        document.getElementById("myDropdown").classList.add("show");
    }

    function hideDropdown() {
        document.getElementById("myDropdown").classList.remove("show");
    }

    // 3. Integrated Search Logic
    function filterSkills() {
        showDropdown();
        const input = document.getElementById('skillSearchInput').value.toLowerCase();
        const items = document.querySelectorAll('.skill-item');
        let foundAny = false;

        items.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(input)) {
                item.style.display = 'flex';
                foundAny = true;
            } else {
                item.style.display = 'none';
            }
        });

        const noResults = document.getElementById('noResults');
        if(noResults) noResults.style.display = foundAny ? 'none' : 'block';
    }

    // 4. Update UI with Selected Tags and Counter
    function updateLabel() {
        const checkboxes = document.querySelectorAll('input[name="skills"]:checked');
        const badge = document.getElementById('skillCountBadge');
        const preview = document.getElementById('selectedSkillsPreview');
        
        if (badge) {
            if (checkboxes.length > 0) {
                badge.style.display = "inline-block";
                badge.innerText = checkboxes.length;
            } else {
                badge.style.display = "none";
            }
        }

        if (preview) {
            preview.innerHTML = ""; 
            checkboxes.forEach(cb => {
                const skillName = cb.nextElementSibling.innerText;
                const tag = document.createElement('span');
                tag.className = 'skill-tag m-1';
                tag.innerHTML = skillName;
                preview.appendChild(tag);
            });
        }
    }

    // 5. Global Event Listener for Closing
    window.addEventListener('click', function(event) {
        const dropdownContainer = document.querySelector('.skills-dropdown');
        const dropdownContent = document.getElementById("myDropdown");
        
        // If the click is NOT inside the dropdown container, close the dropdown
        if (dropdownContainer && !dropdownContainer.contains(event.target)) {
            hideDropdown();
            
            // Clear search input text so all skills show next time it opens
            const searchInput = document.getElementById('skillSearchInput');
            if(searchInput) {
                searchInput.value = "";
                // Reset filter visibility
                document.querySelectorAll('.skill-item').forEach(item => item.style.display = 'flex');
            }
        }
    });

    // Initialize on page load
    window.onload = function() {
        toggleForm();
        updateLabel();
    };
</script>
</body>
</html>