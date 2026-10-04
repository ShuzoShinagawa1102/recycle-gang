package com.recyclegang.backend.customer.application;

import com.recyclegang.backend.shared.BusinessException;
import java.util.HashSet;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CustomerService {
  private final CustomerRepository repository;

  public CustomerService(CustomerRepository repository) {
    this.repository = repository;
  }

  public CustomerProfile get(String id) {
    return repository.get(id);
  }

  @Transactional
  public CustomerProfile lockForBooking(String id) {
    repository.lock(id);
    return repository.get(id);
  }

  @Transactional
  public CustomerProfile save(String id, CustomerProfile profile) {
    if (profile.displayName().isBlank() || profile.addresses().size() > 10)
      throw BusinessException.invalid("表示名と住所（10件以内）を確認してください。");
    var ids = new HashSet<String>();
    for (var a : profile.addresses()) {
      if (a.id().isBlank()
          || a.id().length() > 40
          || !ids.add(a.id())
          || a.addressLine().isBlank()
          || a.prefecture().isBlank()) throw BusinessException.invalid("住所の内容を確認してください。");
    }
    repository.lock(id);
    repository.save(id, profile);
    return repository.get(id);
  }
}
