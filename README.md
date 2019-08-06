# AFImagePicker-Swift
This is image picker manager class for picking image from gallery and camera

DON't forget to add 'NSCameraUsageDescription' for camera and 'NSPhotoLibraryUsageDescription' for photo library

your imagePickerManager should be a class object of your view controller. if you declare it inside body of button tap method, it gets deallocated and delegate methods of imagePicker are not called
