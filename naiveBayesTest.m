function [test_image_labels, error] = naiveBayesTest(phi_attributeK_classI, image_class_labels, image_attribute_labels, numberAttributes, numberClasses)

% Find the number of images
numberImages = size(image_class_labels,1);

% Initialize the image labels matrix
test_image_labels = zeros(numberImages, 1);

% Find the best class for each image based on the phi values
for j = 1:numberImages
    probability_classI = ones(numberClasses, 1);
    
    % Find the probability of each class and find the maximum among them
    maxProbability = 0;
    maxProbabilityClass = 0;
    for i = 1:numberClasses
        % Iterate over all the attributes
        % Probability(i) = (Product over all k) phi(k,i)
        for k = 1:numberAttributes
            row = j.*k;
            if (image_attribute_labels(row,3) == 1)
                probability_classI(i) = probability_classI(i).*phi_attributeK_classI(k,i);
            else
                probability_classI(i) = probability_classI(i).*(1-phi_attributeK_classI(k,i));
            end
        end
        
        % Update the maximum value if needed
        if (probability_classI(i) > maxProbability)
            maxProbabilityClass = i;
            maxProbability = probability_classI(i);
        end
    end
    
    % Set the label for the image as the class with maximum probability
    test_image_labels(j) = maxProbabilityClass;
end

% Find the number of error cases in the test labels
errorCases = 0;
for j = 1:numberImages
    if (image_class_labels(j,2) ~= test_image_labels(j))
        errorCases = errorCases + 1;
    end
end

% Compute the test error
error = errorCases./numberImages;