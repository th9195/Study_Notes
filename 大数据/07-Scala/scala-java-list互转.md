## scala list 与 java list 互转

- **import scala.collection.JavaConverters._**

```scala
import java.util
import scala.collection.JavaConverters._

object Test {
  def main(args: Array[String]): Unit = {
    // 创建 scala list
    var scalaList = List("1", "2", "3")
    // scala list 转 java list
    val javaList: util.List[String] = scalaList.asJava
    // java list 转 Scala list
    scalaList = javaList.asScala.toList
  }
}

```

