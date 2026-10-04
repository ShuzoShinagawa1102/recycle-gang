package com.recyclegang.backend.customer.infrastructure;

import static com.recyclegang.backend.generated.jooq.Tables.*;

import com.recyclegang.backend.customer.application.*;
import com.recyclegang.backend.shared.BusinessException;
import org.jooq.DSLContext;
import org.springframework.stereotype.Repository;

@Repository
public class JooqCustomerRepository implements CustomerRepository {
  private final DSLContext db;

  public JooqCustomerRepository(DSLContext db) {
    this.db = db;
  }

  public void lock(String id) {
    if (db.selectFrom(CUSTOMER).where(CUSTOMER.ID.eq(id)).forUpdate().fetchOne() == null)
      throw BusinessException.missing();
  }

  public CustomerProfile get(String id) {
    var c = db.selectFrom(CUSTOMER).where(CUSTOMER.ID.eq(id)).fetchOne();
    if (c == null) throw BusinessException.missing();
    var addresses =
        db.selectFrom(CUSTOMER_ADDRESS)
            .where(CUSTOMER_ADDRESS.CUSTOMER_ID.eq(id))
            .orderBy(CUSTOMER_ADDRESS.ID)
            .fetch(
                a ->
                    new CustomerProfile.Address(
                        a.getId(),
                        a.getLabel(),
                        a.getPostalCode(),
                        a.getPrefecture(),
                        a.getAddressLine()));
    return new CustomerProfile(c.getDisplayName(), c.getEmail(), c.getPhone(), addresses);
  }

  public void save(String id, CustomerProfile p) {
    db.update(CUSTOMER)
        .set(CUSTOMER.DISPLAY_NAME, p.displayName())
        .set(CUSTOMER.EMAIL, p.email())
        .set(CUSTOMER.PHONE, p.phone())
        .where(CUSTOMER.ID.eq(id))
        .execute();
    db.deleteFrom(CUSTOMER_ADDRESS).where(CUSTOMER_ADDRESS.CUSTOMER_ID.eq(id)).execute();
    for (var a : p.addresses())
      db.insertInto(CUSTOMER_ADDRESS)
          .set(CUSTOMER_ADDRESS.ID, a.id())
          .set(CUSTOMER_ADDRESS.CUSTOMER_ID, id)
          .set(CUSTOMER_ADDRESS.LABEL, a.label())
          .set(CUSTOMER_ADDRESS.POSTAL_CODE, a.postalCode())
          .set(CUSTOMER_ADDRESS.PREFECTURE, a.prefecture())
          .set(CUSTOMER_ADDRESS.ADDRESS_LINE, a.addressLine())
          .execute();
  }
}
