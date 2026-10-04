package com.recyclegang.backend;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

import com.tngtech.archunit.core.importer.ClassFileImporter;
import org.junit.jupiter.api.Test;

class RecycleGangApplicationTests {
  @Test
  void domainDoesNotDependOnInfrastructureOrHttp() {
    noClasses()
        .that()
        .resideInAPackage("..domain..")
        .should()
        .dependOnClassesThat()
        .resideInAnyPackage(
            "org.springframework..",
            "org.jooq..",
            "..generated..",
            "..infrastructure..",
            "..presentation..")
        .check(new ClassFileImporter().importPackages("com.recyclegang.backend"));
  }
}
