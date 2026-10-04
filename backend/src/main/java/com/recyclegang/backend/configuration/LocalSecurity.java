package com.recyclegang.backend.configuration;

import com.recyclegang.backend.shared.LocalIdentity;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.*;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;
import org.springframework.web.cors.*;
import org.springframework.web.filter.OncePerRequestFilter;

@Configuration
@Profile("local")
public class LocalSecurity {
  @Bean
  SecurityFilterChain localSecurityFilterChain(
      HttpSecurity http,
      @Value("${app.consumer-token}") String consumer,
      @Value("${app.manager-token}") String manager,
      @Value("${app.cors-origins}") String origins)
      throws Exception {
    var cors = new CorsConfiguration();
    cors.setAllowedOrigins(Arrays.asList(origins.split(",")));
    cors.setAllowedMethods(List.of("GET", "POST", "PUT", "OPTIONS"));
    cors.setAllowedHeaders(List.of("Authorization", "Content-Type"));
    var source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", cors);
    var filter =
        new OncePerRequestFilter() {
          protected void doFilterInternal(
              HttpServletRequest request, HttpServletResponse response, FilterChain chain)
              throws ServletException, IOException {
            var header = request.getHeader("Authorization");
            if (header != null && header.startsWith("Bearer ")) {
              var value = header.substring(7);
              LocalIdentity identity = null;
              if (equal(value, consumer))
                identity = new LocalIdentity("local-user", "CONSUMER", null);
              else if (equal(value, manager))
                identity = new LocalIdentity("local-manager", "MANAGER", "tokyo-east");
              if (identity != null)
                SecurityContextHolder.getContext()
                    .setAuthentication(
                        new UsernamePasswordAuthenticationToken(
                            identity,
                            null,
                            List.of(new SimpleGrantedAuthority("ROLE_" + identity.role()))));
            }
            chain.doFilter(request, response);
          }
        };
    return http.csrf(c -> c.disable())
        .cors(c -> c.configurationSource(source))
        .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
        .authorizeHttpRequests(
            a ->
                a.requestMatchers(HttpMethod.OPTIONS, "/**")
                    .permitAll()
                    .requestMatchers("/local/**", "/error")
                    .permitAll()
                    .requestMatchers("/api/consumer/**")
                    .hasRole("CONSUMER")
                    .requestMatchers("/api/backyard/**")
                    .hasRole("MANAGER")
                    .anyRequest()
                    .denyAll())
        .exceptionHandling(
            e ->
                e.authenticationEntryPoint(
                        (req, res, ex) ->
                            error(res, 401, "UNAUTHENTICATED", "ローカル認証トークンを確認してください。"))
                    .accessDeniedHandler(
                        (req, res, ex) -> error(res, 403, "FORBIDDEN", "この操作の権限がありません。")))
        .addFilterBefore(filter, AnonymousAuthenticationFilter.class)
        .build();
  }

  private static boolean equal(String a, String b) {
    return MessageDigest.isEqual(
        a.getBytes(StandardCharsets.UTF_8), b.getBytes(StandardCharsets.UTF_8));
  }

  private static void error(HttpServletResponse res, int status, String code, String message)
      throws IOException {
    res.setStatus(status);
    res.setContentType("application/json;charset=UTF-8");
    res.getWriter().write("{\"code\":\"" + code + "\",\"message\":\"" + message + "\"}");
  }
}
