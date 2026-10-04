package com.recyclegang.backend.configuration;

import java.time.Clock;
import org.springframework.context.annotation.*;

@Configuration
public class ApplicationConfig {
  @Bean
  public Clock clock() {
    return Clock.systemUTC();
  }
}
