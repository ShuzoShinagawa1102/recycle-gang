package com.recyclegang.backend.reservation.presentation;

import static org.junit.jupiter.api.Assertions.*;

import com.recyclegang.backend.shared.BusinessException;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import javax.imageio.ImageIO;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockMultipartFile;

class SafePhotoTest {
  @Test
  void verifiesContentAndNormalizesPhoto() throws Exception {
    var image = new BufferedImage(20, 20, BufferedImage.TYPE_INT_RGB);
    var out = new ByteArrayOutputStream();
    ImageIO.write(image, "png", out);
    var jpeg =
        SafePhoto.jpeg(
            new MockMultipartFile("file", "../../fake.png", "image/png", out.toByteArray()));
    assertEquals(0xff, jpeg[0] & 0xff);
    assertEquals(0xd8, jpeg[1] & 0xff);
    assertThrows(
        BusinessException.class,
        () ->
            SafePhoto.jpeg(
                new MockMultipartFile("file", "fake.jpg", "image/jpeg", "not a photo".getBytes())));
    assertThrows(
        BusinessException.class,
        () ->
            SafePhoto.jpeg(
                new MockMultipartFile(
                    "file", "large.jpg", "image/jpeg", new byte[8 * 1024 * 1024 + 1])));
  }
}
