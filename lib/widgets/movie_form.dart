import 'package:eight_app/utils/upload_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../constants/color_constants.dart';
import '../models/movie.dart';
import 'bounce_animation.dart';

class MovieForm extends HookWidget {
  final Movie? movie;
  final Function movieFunction;

  const MovieForm({Key? key, this.movie, required this.movieFunction})
      : super(key: key);

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loading = useState<bool>(false);
    RegExp regExp = RegExp(
      r'(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})',
      caseSensitive: false,
    );
    final _nameController =
        useTextEditingController(text: movie != null ? movie!.name : '');
    final _directorController =
        useTextEditingController(text: movie != null ? movie!.director : '');
    final _imageUrlController =
        useTextEditingController(text: movie != null ? movie!.imageUrl : '');
    final _imageUrl = useState<String>(movie != null ? movie!.imageUrl : '');
    final _imageLoading = useState<bool>(false);

    void _openGallery() async {
      try {
        final picker = ImagePicker();
        final imageFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 1,
        );
        if (imageFile == null) return;
        _imageLoading.value = true;
        final url = await uploadImage(imageFile);
        _imageLoading.value = false;
        _imageUrlController.text = url;
        _imageUrl.value = url;
      } catch (e) {
        print(e.toString());
      }
    }

    void _openCamera() async {
      try {
        final picker = ImagePicker();
        final imageFile = await picker.getImage(
          source: ImageSource.camera,
          imageQuality: 1,
          preferredCameraDevice: CameraDevice.rear,
          maxWidth: 600,
        );
        if (imageFile == null) return;
        _imageLoading.value = true;
        final url = await uploadImage(imageFile);
        _imageLoading.value = false;
        _imageUrlController.text = url;
        _imageUrl.value = url;
      } catch (e) {
        print(e.toString());
      }
    }

    void _showOptions() async {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Pick Image',
            style: Theme.of(context).textTheme.headline6!.copyWith(),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt_rounded),
                label: const Text('Camera'),
                onPressed: () => {
                  _openCamera(),
                  Navigator.of(context).pop(),
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library_rounded),
                label: const Text('Gallery'),
                onPressed: () => {
                  _openGallery(),
                  Navigator.of(context).pop(),
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontFamily: 'OpenSans',
                      color: ColorConstants.SECONDARY,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    Future _validate() async {
      if (_form.currentState!.validate()) {
        try {
          if (_imageUrl.value.isEmpty || _imageLoading.value) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(
                  'Oops!',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontFamily: 'OpenSans',
                      ),
                ),
                content: const Text('Please provide an image'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ok',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontFamily: 'OpenSans',
                            color: ColorConstants.SECONDARY,
                          ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            loading.value = true;
            final id = const Uuid().v4();
            await movieFunction(
              movie != null ? movie!.id : id,
              Movie(
                id: movie != null ? movie!.id : id,
                director: _directorController.text,
                imageUrl: _imageUrlController.text,
                name: _nameController.text,
              ),
            );
            loading.value = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(
                  seconds: 1,
                ),
                backgroundColor: Colors.white,
                content: Text(
                  movie != null
                      ? '${_nameController.text} is updated'
                      : '${_nameController.text} is added',
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            _nameController.clear();
            _directorController.clear();
            _imageUrlController.clear();

            Navigator.of(context).pop();
          }
        } catch (err) {
          loading.value = false;
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Oops!',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontFamily: 'OpenSans',
                    ),
              ),
              content: Text(err.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontFamily: 'OpenSans',
                          color: ColorConstants.SECONDARY,
                        ),
                  ),
                ),
              ],
            ),
          );
          Navigator.of(context).pop();
        }
      } else
        print('Not validated');
    }

    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          // height: 380,
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            10,
          ),
          child: SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(
                          left: 5.0,
                          bottom: 12.0,
                        ),
                        child: Wrap(
                          children: [
                            Text(
                              movie != null
                                  ? 'Update ${movie!.name}'
                                  : 'Add Movie',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                    fontSize: 30.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 5.0,
                          bottom: 12.0,
                        ),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              50.0,
                            ),
                          ),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        child: IconButton(
                          splashRadius: 20.0,
                          icon: const Icon(
                            Icons.close,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _showOptions,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 12.0,
                      ),
                      alignment: Alignment.center,
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20.0,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 12.0,
                            offset: const Offset(
                              0.0,
                              12.0,
                            ),
                          )
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            _imageUrl.value,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: _imageLoading.value
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : _imageUrlController.text.isEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.add_a_photo_rounded),
                                  onPressed: _showOptions,
                                )
                              : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.title,
                      ),
                    ),
                    controller: _nameController,
                    validator:
                        // form_field_validator package
                        MultiValidator(
                      [
                        RequiredValidator(errorText: 'Name is required'),
                        // MinLengthValidator(1,
                        //     errorText: 'Title should be min 1 in length!'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Director',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              30.0,
                            ),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.description,
                        ),
                      ),
                      validator: MultiValidator(
                        [
                          RequiredValidator(
                            errorText: 'Director is required',
                          ),
                          // MinLengthValidator(
                          //   1,
                          //   errorText:
                          //       'Director should be at least 10 characters',
                          // )
                        ],
                      ),

                      controller: _directorController,
                      onFieldSubmitted: (_) =>
                          _validate, // _ means i don't care what that value is beacuse i don't use it
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(
                      20.0,
                    ),
                    child: BounceAnimation(
                      onPress: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all(
                                ColorConstants.PRIMARY,
                              ),
                              elevation: MaterialStateProperty.all(10.0),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                  left: 80.0,
                                  right: 80.0,
                                  top: 20.0,
                                  bottom: 20.0,
                                ),
                              ),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: _validate,
                            icon: loading.value
                                ? const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Icon(
                                    movie != null
                                        ? Icons.update
                                        : Icons.check_circle,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              loading.value
                                  ? 'Loading...'
                                  : movie != null
                                      ? 'Update'.toUpperCase()
                                      : 'Add '.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
