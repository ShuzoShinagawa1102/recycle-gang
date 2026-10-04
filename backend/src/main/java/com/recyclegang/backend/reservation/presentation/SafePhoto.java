package com.recyclegang.backend.reservation.presentation;

import com.recyclegang.backend.shared.BusinessException;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.*;
import javax.imageio.ImageIO;
import org.springframework.web.multipart.MultipartFile;

final class SafePhoto {
  private SafePhoto() {}

  static byte[] jpeg(MultipartFile file) {
    if (file.isEmpty() || file.getSize() > 8 * 1024 * 1024)
      throw BusinessException.invalid("8MB以下のJPEG・PNGを選んでください。");
    try (var input = ImageIO.createImageInputStream(new ByteArrayInputStream(file.getBytes()))) {
      var readers = ImageIO.getImageReaders(input);
      if (!readers.hasNext()) throw BusinessException.invalid("JPEG・PNG画像を選んでください。");
      var reader = readers.next();
      try {
        var format = reader.getFormatName();
        if (!format.equalsIgnoreCase("JPEG") && !format.equalsIgnoreCase("PNG"))
          throw BusinessException.invalid("JPEG・PNG画像を選んでください。");
        reader.setInput(input, true, true);
        if ((long) reader.getWidth(0) * reader.getHeight(0) > 20_000_000)
          throw BusinessException.invalid("写真を2000万画素以下に縮小してください。");
        var decoded = reader.read(0);
        var image =
            new BufferedImage(decoded.getWidth(), decoded.getHeight(), BufferedImage.TYPE_INT_RGB);
        var g = image.createGraphics();
        g.setColor(Color.WHITE);
        g.fillRect(0, 0, image.getWidth(), image.getHeight());
        g.drawImage(decoded, 0, 0, null);
        g.dispose();
        var output = new ByteArrayOutputStream();
        ImageIO.write(image, "jpeg", output);
        if (output.size() > 8 * 1024 * 1024) throw BusinessException.invalid("写真を縮小してください。");
        return output.toByteArray(); // Re-encoding discards EXIF/GPS and untrusted metadata.
      } finally {
        reader.dispose();
      }
    } catch (IOException e) {
      throw BusinessException.invalid("写真を読み取れませんでした。");
    }
  }
}
