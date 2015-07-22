classdef TestStereogramToolbox < matlab.unittest.TestCase
    %TESTSTEREOGRAMTOOLBOX Unit test of the toolbox
    %   Detailed explanation goes here
    
    % 2014-02-15
    % Yimeng Zhang
    % Computer Science Department, Carnegie Mellon University
    % zym1010@gmail.com
    
    properties
    end
    
    methods (Test)
        function testRotation(testCase)
            import stereogram_toolbox.*
            numberOfCases = 200;
            FArray = rand(3,numberOfCases)*5;
            FArray(3,:) = -FArray(3,:); % z should be negative.
            
            for iCase = 1:numberOfCases
                thisF = FArray(:,iCase);
                set_conditions(3.8,thisF,thisF);
                [anglesL, anglesR] = rotation_angles();
                [RyFL] = rotation_matrix(-anglesL(1), 2);
                [RxFL] = rotation_matrix(-anglesL(2), 1);
                
                [RyFR] = rotation_matrix(-anglesR(1), 2);
                [RxFR] = rotation_matrix(-anglesR(2), 1);
                
                PLi = RxFL*RyFL*(thisF - get_conditions().L);
                PRi = RxFR*RyFR*(thisF - get_conditions().R);
                
               % fprintf(['case %d, Li: ' num2str(PLi(:)') ' , Ri: ' num2str(PRi(:)') '\n'], iCase);
                testCase.assertEqual(PLi(1:2),[0;0],'AbsTol',1e-6);
                testCase.assertEqual(PRi(1:2),[0;0],'AbsTol',1e-6);
            end
            
            display(iCase);
        end
        
        function testProjection(testCase)
            import stereogram_toolbox.*
            numberOfCases = 200;
            numberOfPoints = 100;
            FArray = rand(3,numberOfCases)*5;
            FArray(3,:) = -FArray(3,:); % z should be negative.
            
            GArray = rand(3,numberOfCases)*5;
            GArray(3,:) = -GArray(3,:); % z should be negative.
            
            zScreen = -57;
            IO = 3.8;
            for iCase = 1:numberOfCases
                thisF = FArray(:,iCase);
                thisG = GArray(:,iCase);
                set_conditions(IO,thisG,thisF,zScreen);
                R = get_conditions().R;
                L = get_conditions().L;
                
                PArray = rand(3,numberOfPoints)*10;
                PArray(3,:) = -PArray(3,:); % z should be negative.
                
                [SLMatrix, SRMatrix, kLMatrix, kRMatrix, PLMatrix, PRMatrix] = ...
                    screen_coordinates(PArray);
                
                testCase.assertSize(SLMatrix,[3, numberOfPoints]);
                testCase.assertSize(SRMatrix,[3, numberOfPoints]);
                testCase.assertSize(kLMatrix,[1, numberOfPoints]);
                testCase.assertSize(kRMatrix,[1, numberOfPoints]);
                
                testCase.assertEqual(SLMatrix(3,:),repmat(zScreen,1,numberOfPoints),'AbsTol',1e-6);
                testCase.assertEqual(SRMatrix(3,:),repmat(zScreen,1,numberOfPoints),'AbsTol',1e-6);
                
                SLMatrixTemp = bsxfun(@minus, SLMatrix, L);
                SRMatrixTemp = bsxfun(@minus, SRMatrix, R);
                PLMatrixTemp = bsxfun(@times, kLMatrix, PLMatrix);
                PRMatrixTemp = bsxfun(@times, kRMatrix, PRMatrix);
                
                testCase.assertEqual(SLMatrixTemp,PLMatrixTemp,'AbsTol',1e-6);
                testCase.assertEqual(SRMatrixTemp,PRMatrixTemp,'AbsTol',1e-6);
            end
            
            display(iCase);
        end
        
        function testHorizontalDisparity(testCase)
            import stereogram_toolbox.*
            numberOfCases = 200;
            numberOfPoints = 100;
            zScreen = -57;
            
            F = -50-10*rand(numberOfCases,1);
           
            G = -50-10*rand(numberOfCases,1);


            
            IO = 3.8;
            
            for iCase = 1:numberOfCases
                
                set_conditions(IO,[0;0;G(iCase)], [0;0;F(iCase)]);
%                 set_conditions(IO,[0;0;zScreen], [0;0;zScreen]);
                
                PArray = rand(3,numberOfPoints)*10;
                PArray(3,:) = -PArray(3,:); % z should be negative.
                
                [PLiAzi, PLiElevation, PRiAzi, PRiElevation] = ...
                    retina_coordinates(PArray);
                
                testCase.assertSize(PLiAzi,[1, numberOfPoints]);
                testCase.assertSize(PLiElevation,[1, numberOfPoints]);
                testCase.assertSize(PRiAzi,[1, numberOfPoints]);
                testCase.assertSize(PRiElevation,[1, numberOfPoints]);
                
                % use Yang Liu's Vis Res paper to check
                % http://www.journalofvision.org/content/8/11/19
                % Disparity statistics in natural scenes
                
                alpha = 2*atan(-IO/2/F(iCase));
                phi = atan((-PArray(1,:) - IO/2)  ./ PArray(3,:)  ) - ...
                      atan((-PArray(1,:) + IO/2)  ./ PArray(3,:)  );
                
                horizontalDis1 = alpha - phi;
                horizontalDis2 = -PRiAzi + PLiAzi;
                
                testCase.assertEqual(horizontalDis1(:),horizontalDis2(:),'AbsTol',1e-6);
                
                
            end
            
            display(iCase);
        end
        
        
        function testVerticalDisparity(testCase)
            import stereogram_toolbox.*
            numberOfCases = 200;
            numberOfPoints = 100;
            zScreen = -57;
            IO = 3.8;
            set_conditions();
            for iCase = 1:numberOfCases
                
                
                
                PArray = rand(3,numberOfPoints)*10;
                PArray(3,:) = -PArray(3,:); % z should be negative.
                
                PArray(1,:) = 0; % x should be zero to give no vertical disparity difference.
                % however, if we use great circles (longtitude) to be of
                % equal disparity, then we should have no this issue.

                
                [PLiAzi, PLiElevation, PRiAzi, PRiElevation] = ...
                    retina_coordinates(PArray);
                
                testCase.assertSize(PLiAzi,[1, numberOfPoints]);
                testCase.assertSize(PLiElevation,[1, numberOfPoints]);
                testCase.assertSize(PRiAzi,[1, numberOfPoints]);
                testCase.assertSize(PRiElevation,[1, numberOfPoints]);
                
                testCase.assertEqual(PLiElevation,PRiElevation,'AbsTol',1e-6);
                
            end
            
            display(iCase);
        end
        
        function testBarycentric(testCase)
            P = [0 1 0;
                 0 0 1];
            v = [1/3; 1/3];
            lambda = stereogram_toolbox.barycentric_triangle(P,v);
            testCase.assertEqual(lambda,[1/3;1/3;1/3],'AbsTol',1e-6);
        end
        
    end
    
end

