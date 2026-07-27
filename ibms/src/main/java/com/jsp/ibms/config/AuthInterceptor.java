package com.jsp.ibms.config;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    private static final Set<String> PUBLIC_PATHS = new HashSet<>(Arrays.asList(
        "/login.jsp", "/register.jsp", "/forget.jsp", "/index.jsp",
        "/login", "/reg", "/forget", "/", "/generate-otp", "/verify-otp", "/otp-verify.jsp", "/register"
    ));

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        String path = request.getServletPath();

        // Allow static resources
        if (path.startsWith("/css/") || path.startsWith("/images/") || path.startsWith("/js/")) {
            return true;
        }

        // Allow public paths
        if (PUBLIC_PATHS.contains(path)) {
            return true;
        }

        // Allow looking up accounts for transfers (AJAX endpoint)
        if ("/lookup-account".equals(path)) {
            return true;
        }

        // Check session for protected paths
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return false;
        }

        return true;
    }
}
