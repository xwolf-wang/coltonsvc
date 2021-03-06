package com.colton.batch;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.batch.BatchAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.ImportResource;
import org.springframework.data.gemfire.config.annotation.EnablePdx;
import org.springframework.data.gemfire.repository.config.EnableGemfireRepositories;

@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class, BatchAutoConfiguration.class})
@EnableGemfireRepositories(basePackages = "com.colton.entity.repository")
@EnablePdx
@ImportResource(value = "config/clientCache.xml")
public class BatchApplication {
    public static void main(String[] args) {
        SpringApplication.run(BatchApplication.class);
    }
}
