import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:smartagro/annotator/select_image.dart';
import 'package:smartagro/savetodatabase.dart';
//import 'package:phosphor_flutter/phosphor_flutter.dart';

//Global variable for label suggestions
Set<String> labelSuggestions = {};

class AnnotateImage extends StatefulWidget {
  final String email;
  final File? image;

  const AnnotateImage({super.key, required this.image, required this.email});
  @override
  _AnnotateImageState createState() => _AnnotateImageState();
}

class _AnnotateImageState extends State<AnnotateImage> {
  List<RectangleLabel> rectangleLabels = [];
  Offset startPosition = Offset.zero;
  Offset endPosition = Offset.zero;
  TextEditingController labelController = TextEditingController();

  //create a list to store the
  List<List<RectangleLabel>> history = [];
  int historyIndex = -1;
  //default bounding box color
  Color boundingBoxColor = Colors.red;

  bool isFirstRectangle = true;

  @override
  void dispose() {
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Image Annotation'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            //final double containerHeight = constraints.maxHeight * 0.8;
            const double containerHeight = 256;
            const double containerWidth = 256;

            return GestureDetector(
              onPanDown: (details) {
                setState(() {
                  startPosition = _getValidatedPosition(
                    details.localPosition,
                    containerWidth,
                    containerHeight,
                  );
                  endPosition = startPosition;
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  endPosition = _getValidatedPosition(
                    details.localPosition,
                    containerWidth,
                    containerHeight,
                  );
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _showLabelDialog();
                });
              },
              child: Container(
                height: containerHeight,
                width: containerWidth,
                decoration: BoxDecoration(border: Border.all()),
                child: Stack(
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Image.file(widget.image!),
                    ),
                    CustomPaint(
                      painter: RectanglePainter(
                        rectangleLabels: rectangleLabels,
                        currentRect:
                            Rect.fromPoints(startPosition, endPosition),
                        boundingBoxColor: boundingBoxColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(border: Border(top: BorderSide())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    focusColor: Colors.amber,
                    onPressed: () {
                      rectangleLabels.clear();
                      history.clear();
                    },
                    //icon: Icon(PhosphorIcons.regular.trash)),
                    icon: const Icon(Icons.delete)),
                const Text('clear'),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: historyIndex > 0
                        ? () {
                            setState(() {
                              historyIndex--;
                              rectangleLabels =
                                  List.from(history[historyIndex]);
                            });
                          }
                        : null,
                    //icon: Icon(PhosphorIcons.regular.arrowCounterClockwise)),
                    icon: const Icon(Icons.undo)),
                const Text('Undo'),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: historyIndex < history.length - 1
                        ? () {
                            setState(() {
                              historyIndex++;
                              rectangleLabels =
                                  List.from(history[historyIndex]);
                            });
                          }
                        : null,
                    //icon: Icon(PhosphorIcons.regular.arrowClockwise)),
                    icon: const Icon(Icons.redo)),
                const Text('Redo'),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      _showColorPickerDialog();
                    },
                    //icon: Icon(PhosphorIcons.regular.paintBrush)),
                    icon: const Icon(Icons.colorize)),
                const Text('color'),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {
                      navigateToCoordinatesScreen(context);
                    },
                    //icon: Icon(PhosphorIcons.regular.arrowRight)),
                    icon: const Icon(Icons.arrow_right_outlined)),
                const Text('Next'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Offset _getValidatedPosition(
    Offset position,
    double containerWidth,
    double containerHeight,
  ) {
    double x = position.dx.clamp(0.0, containerWidth);
    double y = position.dy.clamp(0.0, containerHeight);
    return Offset(x, y);
  }

  void navigateToCoordinatesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoordinatesScreen(
          rectangleLabels: rectangleLabels,
          email: widget.email,
          image: widget.image!,
        ),
      ),
    );
  }

  void printRectangleCoordinates() {
    for (int i = 0; i < rectangleLabels.length; i++) {
      RectangleLabel rectangleLabel = rectangleLabels[i];
      print('Rectangle ${i + 1}:');
      print(
          'Top Left: (${rectangleLabel.rect.left}, ${rectangleLabel.rect.top})');
      print(
          'Bottom Right: (${rectangleLabel.rect.right}, ${rectangleLabel.rect.bottom})');
      print('Width: ${rectangleLabel.rect.width}');
      print('Height: ${rectangleLabel.rect.height}');
      print('Label: ${rectangleLabel.label}');
      print('');
    }
  }

  void _showLabelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Label'),
        content: TypeAheadField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: labelController,
            decoration: const InputDecoration(
              hintText: 'Enter label',
            ),
          ),
          suggestionsCallback: (pattern) {
            // Filter the labelSuggestions set based on the user input (pattern)
            return labelSuggestions.where(
                (label) => label.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, suggestion) {
            // Display each suggestion in the autocomplete dropdown
            return ListTile(title: Text(suggestion));
          },
          onSuggestionSelected: (suggestion) {
            // When the user selects a suggestion, set it as the label
            labelController.text = suggestion;
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Add'),
            onPressed: () {
              String label = labelController.text.trim();
              if (label.isNotEmpty) {
                setState(() {
                  print('historyIndex before labelling: $historyIndex');
                  rectangleLabels.add(RectangleLabel(
                    rect: Rect.fromPoints(startPosition, endPosition),
                    label: label,
                  ));
                  startPosition = Offset.zero;
                  endPosition = Offset.zero;
                  labelController.clear();
                  // Save current state to history
                  if (isFirstRectangle) {
                    isFirstRectangle = false;
                  } else {
                    history = history.sublist(0, historyIndex + 1);
                  }
                  history.add(List.from(rectangleLabels));
                  historyIndex++;
                  print('historyIndex after labelling: $historyIndex');
                  // Add the label to the labelSuggestions set
                  labelSuggestions.add(label);
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        Color currentColor = boundingBoxColor;

        return AlertDialog(
          title: const Text('Select Bounding Box Color'),
          content: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: (color) {
              setState(() {
                boundingBoxColor = color;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class RectangleLabel {
  final Rect rect;
  final String label;

  RectangleLabel({required this.rect, required this.label});
}

class RectanglePainter extends CustomPainter {
  final List<RectangleLabel> rectangleLabels;
  final Rect currentRect;
  final Color boundingBoxColor;

  RectanglePainter({
    required this.rectangleLabels,
    required this.currentRect,
    required this.boundingBoxColor, // Set default color to red
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint rectanglePaint = Paint()
      ..color = boundingBoxColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    TextStyle labelStyle = TextStyle(
      color: boundingBoxColor,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    );

    for (final rectangleLabel in rectangleLabels) {
      canvas.drawRect(rectangleLabel.rect, rectanglePaint);
      TextSpan span = TextSpan(
        text: rectangleLabel.label,
        style: labelStyle,
      );
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(
        canvas,
        Offset(
          rectangleLabel.rect.left,
          rectangleLabel.rect.top - tp.height - 4.0,
        ),
      );
    }

    canvas.drawRect(currentRect, rectanglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//to display rect coordinates
class CoordinatesScreen extends StatelessWidget {
  final List<RectangleLabel> rectangleLabels;
  final String email;
  final File image;

  const CoordinatesScreen(
      {super.key,
      required this.rectangleLabels,
      required this.email,
      required this.image});

  @override
  Widget build(BuildContext context) {
    String len = rectangleLabels.length.toString();
    double screenheight = MediaQuery.of(context).size.height;
    //double screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Annotated Labels'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            RichText(
                text: TextSpan(
                    text: 'Number of annotations: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    children: [
                  TextSpan(
                    text: len,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ])),
            SizedBox(
              height: screenheight * 0.75,
              child: ListView.builder(
                itemCount: rectangleLabels.length,
                itemBuilder: (context, index) {
                  RectangleLabel rectangleLabel = rectangleLabels[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    columnCount: 1,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 223, 221, 221)),
                          ),
                          child: ListTile(
                            title: Text('Rectangle ${index + 1}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Label: ${rectangleLabel.label}'),
                                Text(
                                  'Top Left: (${rectangleLabel.rect.left}, ${rectangleLabel.rect.top})',
                                ),
                                Text(
                                  'Bottom Right: (${rectangleLabel.rect.right}, ${rectangleLabel.rect.bottom})',
                                ),
                                Text('Width: ${rectangleLabel.rect.width}'),
                                Text('Height: ${rectangleLabel.rect.height}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                uploadAnnotatedImg(email, image, rectangleLabels);

                //return back after submitting the image and data
                Navigator.popUntil(
                  context,
                  (route) =>
                      route is MaterialPageRoute &&
                      route.builder(context).toString() ==
                          SelectImage(email: email).toString(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Submit Annotated Image'),
            ),
          ],
        ),
      ),
    );
  }
}
